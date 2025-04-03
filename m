Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1AE1250BE7;
	Thu,  3 Apr 2025 15:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693955; cv=none; b=DA2S1ZY85RnFiyTCYBipmxoxG/4/TRSaeUUqRQrH2BWCrDrr/6LrhQJLeSdt2mAQgx5bLYTYo7LJfRnEXuZCeuqVAJDnWBsujvlyXcwImH5DK6MaEjnFUPsipMw8xc4QRtYhHhsKAor+mYmq22rGvsQ//26mYuVqaW0P1vrNw3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693955; c=relaxed/simple;
	bh=xcbDClS51o8GOhdcW+Fvtx8/rrFnlarZE3w71Fy9yM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OtHW+dj+wwaGN5xuQZ1ateTGd8cjUnAnliKxC8UN6V+eAINMFdsNheZSzOQNvcxzkv8coBm5n0hrUPvYLpabVWOSWuF3XXeZUYM3B0fPVts2jC8mfSo/rSj3Fh5rtlqXJCTXVsBK2t6rUy6RX57GTtQrFKY8KRSi7ONLy1eUIxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i54xOL3H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i54xOL3H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69AC4C4CEE3;
	Thu,  3 Apr 2025 15:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693955;
	bh=xcbDClS51o8GOhdcW+Fvtx8/rrFnlarZE3w71Fy9yM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i54xOL3HuoFoDyBDSPmwPUIOM5egY68vwbLCOhaPn3bqrwpng01KjW9MluYlj7jKC
	 ahZdaZR8b7wHCylC0EEc+K68eLChD166yH5vS3fMr/G+bn5ja5BQsKNiTt0AvqlZk4
	 QmDKl1X8+2BStpghBC5en+kgvEXhrQL1lSEPcdPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jur van der Burg <jur@avtware.com>,
	Scott Mayhew <smayhew@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.13 04/23] nfsd: fix legacy client tracking initialization
Date: Thu,  3 Apr 2025 16:20:21 +0100
Message-ID: <20250403151622.403482042@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151622.273788569@linuxfoundation.org>
References: <20250403151622.273788569@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Scott Mayhew <smayhew@redhat.com>

commit de71d4e211eddb670b285a0ea477a299601ce1ca upstream.

Get rid of the nfsd4_legacy_tracking_ops->init() call in
check_for_legacy_methods().  That will be handled in the caller
(nfsd4_client_tracking_init()).  Otherwise, we'll wind up calling
nfsd4_legacy_tracking_ops->init() twice, and the second time we'll
trigger the BUG_ON() in nfsd4_init_recdir().

Fixes: 74fd48739d04 ("nfsd: new Kconfig option for legacy client tracking")
Reported-by: Jur van der Burg <jur@avtware.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=219580
Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Tested-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4recover.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -2052,7 +2052,6 @@ static inline int check_for_legacy_metho
 		path_put(&path);
 		if (status)
 			return -ENOTDIR;
-		status = nn->client_tracking_ops->init(net);
 	}
 	return status;
 }


