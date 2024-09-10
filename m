Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3465E184101;
	Tue, 10 Sep 2024 09:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962011; cv=none; b=KRvHGIRxrdMzrdotOKnsq8O1UVCvGTLPkEbZi/FUFpdwRFIP8BP4EI/tjdKTRRekCIe0l+l3W+GjLZEfIYXWEarE9rdu6NiZkDXTpqJw8yvnoQN/ykayqgC88Fxdi5etldnJQFEbk5gUNwEn1X7fdeO9iTbd5aeHfV/syOAOk9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962011; c=relaxed/simple;
	bh=Lie5iIHbx/bobiQ4dN6NCAVcusqdkMdIIe5xsnTM9oA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cahd7TOAGdXBTz0ipEazre4Z1twFkkxjGjTg13or6UaO3CNbwLutLcW0waKOj50o4Pjzh3ItVWl6biYEjfjlmBaP5BJ62vx9pfcVaShPXx+BqdN2EkHcOBAPbRON5KZdfqqfRjkzMw41PBasZY545kmXAMYbA6m64ihRBBUVPCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xCEQ19MH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xCEQ19MH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB0FC4CEC3;
	Tue, 10 Sep 2024 09:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962011;
	bh=Lie5iIHbx/bobiQ4dN6NCAVcusqdkMdIIe5xsnTM9oA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xCEQ19MHlNgOm2mexOXGhIh8hmEsqiw39uOvM9Zfo8p+Bbb/M8zD6iffApm/M4Hau
	 LaBw4HQgzUJEV1H7yCJXm1InV9MhkCj0GxJTJPxlbS76hUhrsE7toAbHuo63ZJV1Lz
	 /xg0FhXX7J3eMSqBuAH9j87n9/fn/so0X0zVagG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+24c0361074799d02c452@syzkaller.appspotmail.com,
	Camila Alvarez <cam.alvarez.i@gmail.com>,
	Silvan Jegen <s.jegen@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 265/375] HID: cougar: fix slab-out-of-bounds Read in cougar_report_fixup
Date: Tue, 10 Sep 2024 11:31:02 +0200
Message-ID: <20240910092631.451171024@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Camila Alvarez <cam.alvarez.i@gmail.com>

[ Upstream commit a6e9c391d45b5865b61e569146304cff72821a5d ]

report_fixup for the Cougar 500k Gaming Keyboard was not verifying
that the report descriptor size was correct before accessing it

Reported-by: syzbot+24c0361074799d02c452@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=24c0361074799d02c452
Signed-off-by: Camila Alvarez <cam.alvarez.i@gmail.com>
Reviewed-by: Silvan Jegen <s.jegen@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-cougar.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-cougar.c b/drivers/hid/hid-cougar.c
index cb8bd8aae15b..0fa785f52707 100644
--- a/drivers/hid/hid-cougar.c
+++ b/drivers/hid/hid-cougar.c
@@ -106,7 +106,7 @@ static void cougar_fix_g6_mapping(void)
 static __u8 *cougar_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 				 unsigned int *rsize)
 {
-	if (rdesc[2] == 0x09 && rdesc[3] == 0x02 &&
+	if (*rsize >= 117 && rdesc[2] == 0x09 && rdesc[3] == 0x02 &&
 	    (rdesc[115] | rdesc[116] << 8) >= HID_MAX_USAGES) {
 		hid_info(hdev,
 			"usage count exceeds max: fixing up report descriptor\n");
-- 
2.43.0



