Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05723322558;
	Mon, 18 Aug 2025 13:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524443; cv=none; b=ZtQ91YDcJuVQ+FVVPuTP2WSr892CgQRTIhAve14N6RfeJFDXO9KWHxgv45G1nGOev3FFzo6b7T1RWSMYybsRPrRBQCGbLfuy8euHK2sRZcqDyhdparCKUDY8bQ1cgSpF8Omo/scLVuP3Ee86FIP2f78FmfeJLdCM7yrs5xXynZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524443; c=relaxed/simple;
	bh=pjv6hl4NrdofHEDKSvKVYO4FlhT+9hqxLFcBLpw+nnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=du0Brg2JwCQTlEjCqX/MvOpZei22+C6sM2IU7URrdmLfX+VUmRdOen8nOpy8yO9KS4HSHWTjc+WEtAIHODpmlMxfwCTYfUodoNFA1OxVKnwH2n8s2lG7JenTwDSvPj9jc+NCr/ucKu1mOaq4v612zCiUp6UrriGg7T8CXVPkUEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fVuF50++; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fVuF50++"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67759C4CEF1;
	Mon, 18 Aug 2025 13:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524442;
	bh=pjv6hl4NrdofHEDKSvKVYO4FlhT+9hqxLFcBLpw+nnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fVuF50++H0DD2DbDL2ElT0VhfPEnjgCKwGdxZJibXU262LCdp09aSmpf5cYvNoV5O
	 C1+yHfvQAUf2ikBZSVotIUl6ed72PR965xVqPs2xB0HIy7Tavw7ydsNkEakUOT+WDE
	 VgE337KHMWLV+PzQeSRUgjlTouN6owxSYt1jHSxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.15 466/515] btrfs: qgroup: set quota enabled bit if quota disable fails flushing reservations
Date: Mon, 18 Aug 2025 14:47:32 +0200
Message-ID: <20250818124516.357137712@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit e41c75ca3189341e76e6af64b857c05b68a1d7db upstream.

Before waiting for the rescan worker to finish and flushing reservations,
we clear the BTRFS_FS_QUOTA_ENABLED flag from fs_info. If we fail flushing
reservations we leave with the flag not set which is not correct since
quotas are still enabled - we must set back the flag on error paths, such
as when we fail to start a transaction, except for error paths that abort
a transaction. The reservation flushing happens very early before we do
any operation that actually disables quotas and before we start a
transaction, so set back BTRFS_FS_QUOTA_ENABLED if it fails.

Fixes: af0e2aab3b70 ("btrfs: qgroup: flush reservations during quota disable")
CC: stable@vger.kernel.org # 6.12+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/qgroup.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1354,11 +1354,14 @@ int btrfs_quota_disable(struct btrfs_fs_
 
 	/*
 	 * We have nothing held here and no trans handle, just return the error
-	 * if there is one.
+	 * if there is one and set back the quota enabled bit since we didn't
+	 * actually disable quotas.
 	 */
 	ret = flush_reservations(fs_info);
-	if (ret)
+	if (ret) {
+		set_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
 		return ret;
+	}
 
 	/*
 	 * 1 For the root item


