Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118761E497;
	Thu, 23 May 2024 13:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470166; cv=none; b=n+AovbL78U3DPILckUPPegKBN8eRtb2TG/qsrbjMi58LRPxfGfFK0O6Y3ErVEL07Erw1muH1cTPvVewNLKKJChwzgeyu3uTVxye6gf+RTsAXylOrbA290Hx++xTsX2541IDCbqOVmSObHVbgH7/tbuiyZDt8aZ9tSTu1a84BnBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470166; c=relaxed/simple;
	bh=1pHtBVXv7BLKyMSdc/KM94DsTKG/7tLuWFPAsFd8rU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bh9m4KQdbKNQEkmsu1OcX6fjqbmoVxIqE1Xs3wi3taQ7YlnPAVDEmhDFf8iPMBi6PqT6+OoeFw8208f9lUNdU7lV3OL7e+b5YtNnvgctSPNRAZhIocaTsYWdUuWtyvVspgANqoyCtHHqJ0X4hEX+TJVDpW/lIbHl3ym31FqWnLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sX6VuqwC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sX6VuqwC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44060C3277B;
	Thu, 23 May 2024 13:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470165;
	bh=1pHtBVXv7BLKyMSdc/KM94DsTKG/7tLuWFPAsFd8rU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sX6VuqwCi+hisMO+ljYIn/88KB5zyzuqJ4EOS0YtVqqyHnIEXe1XxJGKgrmqa3B+i
	 WTHkOvS31+3a5lKljheyzi1RLIlXfqCe3Ng0unT2mgD15UV03lsE0vliAOzwPajLnZ
	 PEqgyphMPtW9o5UhEbQEopxofd7zskSPB3e+4w/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Machek <pavel@denx.de>,
	Dominique Martinet <dominique.martinet@atmark-techno.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 12/16] btrfs: add missing mutex_unlock in btrfs_relocate_sys_chunks()
Date: Thu, 23 May 2024 15:12:45 +0200
Message-ID: <20240523130326.211485861@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130325.743454852@linuxfoundation.org>
References: <20240523130325.743454852@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominique Martinet <dominique.martinet@atmark-techno.com>

commit 9af503d91298c3f2945e73703f0e00995be08c30 upstream.

The previous patch that replaced BUG_ON by error handling forgot to
unlock the mutex in the error path.

Link: https://lore.kernel.org/all/Zh%2fHpAGFqa7YAFuM@duo.ucw.cz
Reported-by: Pavel Machek <pavel@denx.de>
Fixes: 7411055db5ce ("btrfs: handle chunk tree lookup error in btrfs_relocate_sys_chunks()")
CC: stable@vger.kernel.org
Reviewed-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3277,6 +3277,7 @@ again:
 			 * alignment and size).
 			 */
 			ret = -EUCLEAN;
+			mutex_unlock(&fs_info->delete_unused_bgs_mutex);
 			goto error;
 		}
 


