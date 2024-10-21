Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC381E47CD;
	Mon, 21 Oct 2024 10:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507198; cv=none; b=iVvszYFG8GfQ3OUEUarTp9tJNL9ZBp37quczWfGMsi3Z8guFs576dFFlZQXRfTcJsQXOSA6IdJzFZhgV7aiaXxVAOUEpSGcte6Mynmm4Fe9BET1+r33dGQMsMpf+KG+OBaAQXE9s1+3256ly3ET0zdCL6TH0uuNE7KUH2bF8its=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507198; c=relaxed/simple;
	bh=NsCHxQo+4T/44bLrh+pmwLdQJ1ow6GIAXmXLJyj049w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBSiRoClNnyTjE0MdTDMDSGbyiJf4uNTJ1faL+/dmVWP6IEDhZBlcM+7munM1J2iuJcpKU4zqc3PDtNygJCt9NZ+G5IbjuRiP5Rmwi4FJg3sghBEy0bJ8eibA9xKADJ0BuWvEHaTnCmEGj9cadn7e36cooKIeVT/RwrIc+eYpoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jv0qT5HP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jv0qT5HP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3937C4CEC3;
	Mon, 21 Oct 2024 10:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507198;
	bh=NsCHxQo+4T/44bLrh+pmwLdQJ1ow6GIAXmXLJyj049w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jv0qT5HPz/Wb7hmCtGZQQPDl8lxewlLlYZ3Gcp3dxLEtzqJpNHO4uujcb1Z+h2d8T
	 Bys273vbvx98Lqw2Wjr1brJBqtcNsGn6adWSHI6UxNvhyKpGU40TfalTyZbaUcg3gY
	 SwdeZaOVQ5W6tp+psUvVVlbcLR8raPVgQjl6KNvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+955da2d57931604ee691@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>
Subject: [PATCH 6.6 091/124] vt: prevent kernel-infoleak in con_font_get()
Date: Mon, 21 Oct 2024 12:24:55 +0200
Message-ID: <20241021102300.246144855@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeongjun Park <aha310510@gmail.com>

commit f956052e00de211b5c9ebaa1958366c23f82ee9e upstream.

font.data may not initialize all memory spaces depending on the implementation
of vc->vc_sw->con_font_get. This may cause info-leak, so to prevent this, it
is safest to modify it to initialize the allocated memory space to 0, and it
generally does not affect the overall performance of the system.

Cc: stable@vger.kernel.org
Reported-by: syzbot+955da2d57931604ee691@syzkaller.appspotmail.com
Fixes: 05e2600cb0a4 ("VT: Bump font size limitation to 64x128 pixels")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Link: https://lore.kernel.org/r/20241010174619.59662-1-aha310510@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -4550,7 +4550,7 @@ static int con_font_get(struct vc_data *
 		return -EINVAL;
 
 	if (op->data) {
-		font.data = kvmalloc(max_font_size, GFP_KERNEL);
+		font.data = kvzalloc(max_font_size, GFP_KERNEL);
 		if (!font.data)
 			return -ENOMEM;
 	} else


