Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B7734D386;
	Fri, 21 Nov 2025 13:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733146; cv=none; b=Qotwdmgh4KgXqJ23xCO4aHaeyGdG03YBbOyU36C4WPqfrWvySLZ68HsNzPBv1c1fISUYbl7AdDR0Mzv5GNr1Dvk7AvBUKKxsEJK61zsE7HSrP0i6w86bXGPWrmud7u4u63XjYoeTQVrflS9gr5X3AL8oZ65d6RZUijo3ApeT4as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733146; c=relaxed/simple;
	bh=iAbkt7+1szicb3OKdhgKPkwhR9ku2rnzNRNFURzkCxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bT7sIzYiMPhPi0+h0fv1SzZTGAJzfhePp5WTUJ93Xn//F5LlFcS4cbcM+jkBB2zkgf8W8ekoITC0VzY1brOGuxfO3ZQkg6SEgmYuDmyQvxE4R/JqBeP4OQcTvAN3RmsIy20trZmNmekRYiHD3hZYHvBnnM+BtZj1j1ObyBuJ6t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nWeeGtjn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nWeeGtjn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124FAC4CEF1;
	Fri, 21 Nov 2025 13:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733146;
	bh=iAbkt7+1szicb3OKdhgKPkwhR9ku2rnzNRNFURzkCxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nWeeGtjnOor6WY6Cmd+TQEKjpxP0flQFK9JCA3ECz/NKLz0uzrCIA3FVhBz2dt6iC
	 4vIWPR98wdassknrhX2D8NGx9ltPUhNO36WsLbcVTuEkyWv11pdehG18qRIdf27r0H
	 OhUj8yc2qrk0Vav/PV70WlOpGUXjxMTE+jjguAS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Rogers <linux@joshua.hu>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 367/529] smb: client: validate change notify buffer before copy
Date: Fri, 21 Nov 2025 14:11:06 +0100
Message-ID: <20251121130244.086285627@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Rogers <linux@joshua.hu>

commit 4012abe8a78fbb8869634130024266eaef7081fe upstream.

SMB2_change_notify called smb2_validate_iov() but ignored the return
code, then kmemdup()ed using server provided OutputBufferOffset/Length.

Check the return of smb2_validate_iov() and bail out on error.

Discovered with help from the ZeroPath security tooling.

Signed-off-by: Joshua Rogers <linux@joshua.hu>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: stable@vger.kernel.org
Fixes: e3e9463414f61 ("smb3: improve SMB3 change notification support")
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4068,9 +4068,12 @@ replay_again:
 
 		smb_rsp = (struct smb2_change_notify_rsp *)rsp_iov.iov_base;
 
-		smb2_validate_iov(le16_to_cpu(smb_rsp->OutputBufferOffset),
-				le32_to_cpu(smb_rsp->OutputBufferLength), &rsp_iov,
+		rc = smb2_validate_iov(le16_to_cpu(smb_rsp->OutputBufferOffset),
+				le32_to_cpu(smb_rsp->OutputBufferLength),
+				&rsp_iov,
 				sizeof(struct file_notify_information));
+		if (rc)
+			goto cnotify_exit;
 
 		*out_data = kmemdup((char *)smb_rsp + le16_to_cpu(smb_rsp->OutputBufferOffset),
 				le32_to_cpu(smb_rsp->OutputBufferLength), GFP_KERNEL);


