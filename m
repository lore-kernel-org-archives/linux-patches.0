Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E811D2EBB84;
	Tue, 12 May 2026 17:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607986; cv=none; b=VI9eedyaldaxWlYlOhHyuocoAvAIu//Xf0IylEe344zWBykS6VfjbXejXVBQSd3TKQjKGJcq/jJ2r8WA13TkJO+HCwyEP3YYaSqxJbkNiXpcHe/TK/TqKMnmWhyUE5JScaVHGg7yD4PO5fkchli8Ou+RBfrJguSqrFbMo+vzpgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607986; c=relaxed/simple;
	bh=cD/QSpLjxAW0kAegwhCaitGrqXgaBASMGCWFkM3WgEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cGJqO3k0rtKq0gDSp6rYsDsbRos4TN7x0zTGsiuoZG10mTijCkHXSr+haEQlSgfw0XFFivJqoBOuCpPqGwDV3bRmCID5UDzXOUtfFrWt3pUNuw53dVMYnxNdoyi5k1lC/kcw9amU4TFSathTyx+mc8C43MWUcgwCTJw58QOluD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LihPSdtl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LihPSdtl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D52BC2BCF5;
	Tue, 12 May 2026 17:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607985;
	bh=cD/QSpLjxAW0kAegwhCaitGrqXgaBASMGCWFkM3WgEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LihPSdtlSA8Hj1kMWvEsgtEnLZm+hLRNe0iapYSfqBNFsdRtLEyQ2plkeqLDKkwgr
	 8Nu7O6UetqY0xP1INy6ImFxPabCn6NC4M3c3PJCqlhun2uX1cDloCoyRxoqy7PvItM
	 iJ3xtiO2d6VQOfDPDdnOEeBagD4b1Et5/4GVmdAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 113/206] ASoC: qcom: q6apm: remove child devices when apm is removed
Date: Tue, 12 May 2026 19:39:25 +0200
Message-ID: <20260512173935.248434717@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

commit 4a0e1bcc98f7281d1605768bd2fe71eacc34f9b7 upstream.

looks like q6apm driver does not remove the child driver q6apm-dai and
q6apm-bedais when the this driver is removed.

Fix this by depopulating them in remove callback.

With this change when the dsp is shutdown all the devices associated with
q6apm will now be removed.

Fixes: 5477518b8a0e ("ASoC: qdsp6: audioreach: add q6apm support")
Cc: Stable@vger.kernel.org
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20260402081118.348071-3-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/q6apm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/qcom/qdsp6/q6apm.c
+++ b/sound/soc/qcom/qdsp6/q6apm.c
@@ -781,6 +781,7 @@ static int apm_probe(gpr_device_t *gdev)
 
 static void apm_remove(gpr_device_t *gdev)
 {
+	of_platform_depopulate(&gdev->dev);
 	snd_soc_unregister_component(&gdev->dev);
 }
 


