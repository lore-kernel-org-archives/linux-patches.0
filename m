Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F42C3FBB73;
	Fri, 15 May 2026 16:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861997; cv=none; b=mQiXw0f0dBG+JABxG7NfCOG6Z1XEmWLYlXJZGJFVYmtVb6CZ0akwW24wz5R8AjzJHGkY6IsydOXrQQIdRD1DQ3VF3i0TanVsax3Dwnyecenwx9RBpBYZHqHgyJ8RBbmAEOCMOv6Z/huU8sGYJcibLexU9t3EqaCWYgF1QcnoIHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861997; c=relaxed/simple;
	bh=u8JY4Qw9TQdgYWygVgwD1V+9n7mmlZHvJDe845d7TbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGv1xRaFagcPYkkVFSFl4p18r5KuvZrtNkKf3mV7mmEz9tXUH3nj5dHv20FFdXrmTtzeBznFgZSa0iiRU5Ws3bgmeZzZ1cLWnv7jf64YTvKCCNUvWuuKca/lgmkdhILT+FSOFPIrdp5k756VtSunDSLRkTkY1N2fkGWL7s7ftfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=stZaacLV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="stZaacLV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71615C2BCB0;
	Fri, 15 May 2026 16:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861996;
	bh=u8JY4Qw9TQdgYWygVgwD1V+9n7mmlZHvJDe845d7TbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=stZaacLV5NlFL478wAGE0s2M9Tk+yoar/OMKUMxoRM+YNxz4mh1dm1C1EIL2Zg0mU
	 CIC4wvVvx6ovqoFt7EipGI4Xy84APwV5SHXIQ3b9d9w07ctH6qgcD6HNWnhv2Y7pbw
	 cPdlCtUkwykCxTitTxEDasnBPAapMgO5h9F5IMTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 025/188] regulator: max77650: fix OF node reference imbalance
Date: Fri, 15 May 2026 17:47:22 +0200
Message-ID: <20260515154657.854111056@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 2edaf5f7ada0ab5c9ec1f0836bd19779a8d85262 upstream.

The driver reuses the OF node of the parent multi-function device but
fails to take another reference to balance the one dropped by the
platform bus code when unbinding the MFD and deregistering the child
devices.

Fix this by using the intended helper for reusing OF nodes.

Fixes: bcc61f1c44fd ("regulator: max77650: add regulator support")
Cc: stable@vger.kernel.org	# 5.1
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260408073055.5183-4-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/max77650-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/max77650-regulator.c
+++ b/drivers/regulator/max77650-regulator.c
@@ -337,7 +337,7 @@ static int max77650_regulator_probe(stru
 	parent = dev->parent;
 
 	if (!dev->of_node)
-		dev->of_node = parent->of_node;
+		device_set_of_node_from_dev(dev, parent);
 
 	rdescs = devm_kcalloc(dev, MAX77650_REGULATOR_NUM_REGULATORS,
 			      sizeof(*rdescs), GFP_KERNEL);


