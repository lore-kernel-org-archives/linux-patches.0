Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E29A26FA65;
	Tue,  8 Apr 2025 13:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117203; cv=none; b=GQw8V4TJ+wxBzTrcYCxVKyMaKeiglwKLMFlxoT9J83wFG/hj1y3VC0GU6MfmHEv61DgWEAMUMlskWHLcbZdgvgRNkln1k8es1UwVygdI1uRrJ2P7M5/BaRJFWWIla09QzZMr+1gcG/kBEzJBZpbolnRwHCEHA4Qrlz/ehcxpxUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117203; c=relaxed/simple;
	bh=YoBPgyhl/U4Itgpw2VesmYerdvBfNjwhBLPmKFYnd7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujdGBWLmSdgMr7L5gDH7reoDLGofi6CBd2ys21O7itf21gMyiVLOcZXCRE+x9ZcJtk/9InP2z7y83IpKct4H4Lxb/6gV7M0yD0zd0nIfBqVSv6vVO5LPOiA0AQ64FzlTZyRU5kmo3wnIPshpRB9yClw45EpSwka9pHIHyCmkB20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q3q5wLso; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q3q5wLso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944ADC4CEE5;
	Tue,  8 Apr 2025 13:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117203;
	bh=YoBPgyhl/U4Itgpw2VesmYerdvBfNjwhBLPmKFYnd7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q3q5wLsoyVGXlvWE6dIVVCUsqIfmt5182W6Q4Uj7OA6gjLhE2Gnp7eZBOaDkYmzTa
	 qlw1RjdoPOcIjir3F/sN/+++VaV8FovqrnknTAhxowcEuC+maRUw1W6v1fEvVW0NOh
	 wIOr39ktPq8B3vpV7me7s1+oh62R5oNuuwglLuTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 421/423] NFSD: nfsd_unlink() clobbers non-zero status returned from fh_fill_pre_attrs()
Date: Tue,  8 Apr 2025 12:52:27 +0200
Message-ID: <20250408104855.741762102@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit d7d8e3169b56e7696559a2427c922c0d55debcec upstream.

If fh_fill_pre_attrs() returns a non-zero status, the error flow
takes it through out_unlock, which then overwrites the returned
status code with

	err = nfserrno(host_err);

Fixes: a332018a91c4 ("nfsd: handle failure to collect pre/post-op attrs more sanely")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/vfs.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -2015,11 +2015,9 @@ out_nfserr:
 		 * error status.
 		 */
 		err = nfserr_file_open;
-	} else {
-		err = nfserrno(host_err);
 	}
 out:
-	return err;
+	return err != nfs_ok ? err : nfserrno(host_err);
 out_unlock:
 	inode_unlock(dirp);
 	goto out_drop_write;


