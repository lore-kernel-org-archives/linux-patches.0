Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062219;
	b=IFL5rOC4jzl+GMVw+J1xj1iF6Q2bHgqEowyBaTpz9Ar4jth8CEaHXnpXQq+lIQ/xOg06
	 YnJrDxzDnqJVUPzoQVR2bVESHQMyhetK0V2cKeMmCSNtVm+eyMbR7SCqU9GejK1j5MSvo
	 fG5sCOea127yE0gORQCVOAeO1LklJR2EUXwqGbPepBcic+33fp1XeV2haCfA27cQ0Dbzu
	 /dIf2QhkWSP8UUl6ZqAd4gOesEC/2fnTfDSp+RgpRzkMt4jv9ewMPTdavMB8GtJBby/Zw
	 Dnhq8Ehw5ZdbuGbsE6+WAytr39slnccfpgdw/wxXtMW8+Ykxq8dW2IxjsEnP1LL/ttw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062219;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9oylAkL70tvV4Tw7NI9pwv3girIDV+NwJ6/uKpEjP+k=;
	b=Zb7eYwBxXGEclM5MBbOprDlO1ieF520vxNbzilNXlaY4C9qgV8SWfTGmIKw3O18YziNW
	 asFSyXMJ+NAdSjNqvf92lQbFlQ8VIHRD7OklrFTx6pDXh0FIH1JpwN0iuCN35IDzMLHXq
	 YpRqGY8G5g4YKKVEF6gz32vqF+y8Y2Oj2UyRwDtCPufswjVlnlMC/y5DqP3iKh5lDS6VM
	 19x5C4YQOXbjMOEofwzvTtO2l0oOmeKLrrpKphNVZhi+fsONs648VHwf71L8d2Wid3OMe
	 FIxjrfaFi743m+VXCS6CrsM1/CsY9njajXl4qR7l2DNmuPWEJqlmj32H59jXomqxQcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rJl4Ghzy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E18606A325;
	Thu, 19 Nov 2026 04:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rJl4Ghzy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F11B1F000C4;
	Thu, 19 Nov 2026 04:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062219;
	bh=9oylAkL70tvV4Tw7NI9pwv3girIDV+NwJ6/uKpEjP+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rJl4GhzyaBHIgbcA+byp2+d0T3Mng1oYggncnwoW1krbh1k/J4VEXFurZ4ndZjCH/
	 fHBClySLXYKn7y9lbUTfjvgVF6nF938RvSlTUnEDwJa53xPOBuvzi4vldkGHd3Wup/
	 esuMcB0rS6zh3v/5v3QS6j+QlB0O76dTZt2xiYuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Radu Rendec <radu@rendec.net>
Subject: [PATCH 5.10 1833/1848] irqchip/gic-v3-its: Fix its node leak in gic_acpi_parse_madt_its()
Date: Wed, 18 Nov 2026 16:04:31 +0100
Message-ID: <20261118150036.366123381@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

commit 698a8648ca8051d34722b09b8a8088c741120ac3 upstream.

Fix its node leak when its_probe_one() failed in
gic_acpi_parse_madt_its().

Fixes: 9585a495ac936 ("irqchip/gic-v3-its: Split allocation from initialisation of its_node")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Radu Rendec <radu@rendec.net>
Link: https://patch.msgid.link/20260702033050.1583-3-shikemeng@huaweicloud.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-gic-v3-its.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -5602,9 +5602,13 @@ static int __init gic_acpi_parse_madt_it
 	}
 
 	err = its_probe_one(its);
-	if (!err)
-		return 0;
+	if (err)
+		goto probe_err;
 
+	return 0;
+
+probe_err:
+	its_node_destroy(its);
 node_err:
 	iort_deregister_domain_token(its_entry->translation_id);
 dom_err:


