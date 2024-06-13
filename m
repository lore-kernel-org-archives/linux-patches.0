Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0ABE3209;
	Thu, 13 Jun 2024 12:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281665; cv=none; b=ns3BH9v7q7lD1ucLM8vPOJGEabnHpOsZxo7o55Rd87UwtNjqPn5xNCk9s555xTiECYP0YQnCeyj5ObABr4O8y0W5uPeBg2WtrEqhWZiQ2fTuflDBj/UDv6Ehf6TULYbco4bBPFTpuNxMH0FW45qwW7rglZHF059J5tLDdJQyXQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281665; c=relaxed/simple;
	bh=vw6ABlzcWGKIcHjIWKaAtKQ6mQHnxc6grsSwjV5GKzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HpcLJv2r6U23jH+oLpptctiUjf/3lrW8SCsU/SZjMwptGQ3kZz9GWobpBZAfA97C+qgitxIeEtquUdr3k+7TGE9rnM26LlnSHSaRi986VmA5Oc1X8ib8N+op7IHpnBztqGHCWO2FVSjR7sVbZ1GXJMIYY1IO4hsxjxlAdmVH2BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fOOGNFTC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fOOGNFTC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28324C2BBFC;
	Thu, 13 Jun 2024 12:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281665;
	bh=vw6ABlzcWGKIcHjIWKaAtKQ6mQHnxc6grsSwjV5GKzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fOOGNFTC0IWvfU/h5A+ZH9PqTAu5HzL0XfZXaToZoO21RvMoFWU3tfXoz71Trl//W
	 fBMU1zvLnPs0ey6cAWMo70fZhybUWPL7o4t+jLHlALaF84YKiFJM6fOUxmwV9wp7VG
	 gNm+wUFqIiSn/O/SFDuXe+peGcZ6gXo62tn2pPN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH 5.15 004/402] speakup: Fix sizeof() vs ARRAY_SIZE() bug
Date: Thu, 13 Jun 2024 13:29:21 +0200
Message-ID: <20240613113302.296234675@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 008ab3c53bc4f0b2f20013c8f6c204a3203d0b8b upstream.

The "buf" pointer is an array of u16 values.  This code should be
using ARRAY_SIZE() (which is 256) instead of sizeof() (which is 512),
otherwise it can the still got out of bounds.

Fixes: c8d2f34ea96e ("speakup: Avoid crash on very long word")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Link: https://lore.kernel.org/r/d16f67d2-fd0a-4d45-adac-75ddd11001aa@moroto.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accessibility/speakup/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/accessibility/speakup/main.c
+++ b/drivers/accessibility/speakup/main.c
@@ -573,7 +573,7 @@ static u_long get_word(struct vc_data *v
 	}
 	attr_ch = get_char(vc, (u_short *)tmp_pos, &spk_attr);
 	buf[cnt++] = attr_ch;
-	while (tmpx < vc->vc_cols - 1 && cnt < sizeof(buf) - 1) {
+	while (tmpx < vc->vc_cols - 1 && cnt < ARRAY_SIZE(buf) - 1) {
 		tmp_pos += 2;
 		tmpx++;
 		ch = get_char(vc, (u_short *)tmp_pos, &temp);


