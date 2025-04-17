Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36A5253B7B;
	Thu, 17 Apr 2025 18:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913584; cv=none; b=E+DRRZp0jXzfhGPoT3CreETSpXicIIVANcDZENlvl354rtR5fmSZbgnpJtCbqvEwLGinbKJ8pFLnInhmRtgi4zx4gNlUA0a4ZCTF6sNjifBOaeP/tdHtC/ORhx3rxt9VPvvCOyVrj74aABTSPtPD4cyw61I62jHh1t3fg2nU2DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913584; c=relaxed/simple;
	bh=p629mVzcrqlyNLKgkNSu2+iFQ7K2wOxy/YtQw/ppTCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rh6dxFKoglRQ1H+v2Wq3hnc1ISIGCc1zF1Eq//bshK7OhwuTDatOHzoswntaiJxWVRyw9oeZZp+udx2rtpG/ROVawTtRfyh1IGeGYINlozfOsixooI5Fh+230PLvEL3Sh+/uuNHWuSxkJ16glkFiDudIpaObUN2OOKnWam9JTk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pceI9VOh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pceI9VOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDD1C4CEEA;
	Thu, 17 Apr 2025 18:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913584;
	bh=p629mVzcrqlyNLKgkNSu2+iFQ7K2wOxy/YtQw/ppTCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pceI9VOheLTiY/4uoSds8/Au/+5Gsg1X//uI23ynkC03+BU1qVVK0ztoX4P7pYfDv
	 klqIcPRNVNj2aUV/vPliWWxr90Q+bvwXXuJmZkVnJyRCK32uAaG8zxZFT4Ec00wACW
	 r7Y8kYmDGrPu9a0ooO3AM8k2K6INIIpjV6RAxRAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>
Subject: [PATCH 6.14 386/449] dlm: fix error if active rsb is not hashed
Date: Thu, 17 Apr 2025 19:51:14 +0200
Message-ID: <20250417175133.801522170@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Aring <aahringo@redhat.com>

commit a3672304abf2a847ac0c54c84842c64c5bfba279 upstream.

If an active rsb is not hashed anymore and this could occur because we
releases and acquired locks we need to signal the followed code that
the lookup failed. Since the lookup was successful, but it isn't part of
the rsb hash anymore we need to signal it by setting error to -EBADR as
dlm_search_rsb_tree() does it.

Cc: stable@vger.kernel.org
Fixes: 5be323b0c64d ("dlm: move dlm_search_rsb_tree() out of lock")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dlm/lock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -741,6 +741,7 @@ static int find_rsb_dir(struct dlm_ls *l
 	read_lock_bh(&ls->ls_rsbtbl_lock);
 	if (!rsb_flag(r, RSB_HASHED)) {
 		read_unlock_bh(&ls->ls_rsbtbl_lock);
+		error = -EBADR;
 		goto do_new;
 	}
 	


