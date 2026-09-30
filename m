Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291E65172E0;
	Wed, 30 Sep 2026 17:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788079; cv=none; b=uusRI2wSC5sHy4cYJGfKT2SFrat3y1NxJ9Ediqr2bqWEP8WW2iOmt59o5hfUUTsjUQjonQYccaiFb7YWeU2BbazOMT7QBgTcteOBFaQHVMsfPrmsFqwtKV/f5dUt1PNz1PHPxQD2oiv01HWg8ELjgz0QeP4YuGd0TmbX0c7F8mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788079; c=relaxed/simple;
	bh=NVbEXCEaCdLJh0ezHx/Tn5KAnVtnXpFxbzUio/dXfYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TpHHV2v59RgBmssYy2aEzrYDshoyJaYrkO7xXVm1b5IopdB1PxgGMsa9Wo7r0DJEUsC+H60CjInnooCTAmJoLSoa1m2vr8caQVDhpkLXH556eZFgNYrEQanoIRC2Kr3hsWfEg/vU4bifm1PDXoTO0928VFpewKnwQ1yNB8mSXLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mEZv7AiJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mEZv7AiJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B211F000FF;
	Wed, 30 Sep 2026 17:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788078;
	bh=h8wQgGqKSJ1Or7djBEfDXJIRJq9ymtMS3H6Hzxt9r7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mEZv7AiJhki98vzgC3qeCsZ/rZgkP5/9nolhBz1ZA7BL2Ch2Pt9eC7ERU0yn41urF
	 LcSZsGRd1UUcUO/eLvcSuIKk36a64yX3IpS7BZ0DODXVHpgIEGdJ1hc/qRZgUyqGWv
	 6fVWmyv4IsuSX7U6GLqjpfruy+0U5+bzr77lwyig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengzhuo Wei <me@cherr.cc>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mukesh Kumar Savaliya <mukesh.savaliya@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 7.2 457/457] i2c: qcom-geni: release DMA channels on probe error
Date: Wed, 30 Sep 2026 17:29:22 +0200
Message-ID: <20260930152355.870579328@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengzhuo Wei <me@cherr.cc>

commit 268aacb2e2a5c94d08e23194961234d0710c8407 upstream.

geni_i2c_init() grabs exclusive GPI tx/rx DMA channels when the serial
engine runs in GPI mode. If i2c_add_adapter() subsequently fails, probe
returns without releasing the channels, because the remove callback is
not invoked after a failed probe.

The adapter-registration failure path used to release the channels via
its err_dma label; that release was dropped when the probe tail was
restructured into geni_i2c_init().

Release the channels on the adapter-registration failure path, mirroring
geni_i2c_remove().

Fixes: d8d3bb127ad1 ("i2c: qcom-geni: Isolate serial engine setup")
Assisted-by: GLM:5.3
Signed-off-by: Shengzhuo Wei <me@cherr.cc>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Mukesh Kumar Savaliya <mukesh.savaliya@oss.qualcomm.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20260827-i2c-dma-channel-leak-v1-3-271d4adc03a0@cherr.cc
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-qcom-geni.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i2c/busses/i2c-qcom-geni.c
+++ b/drivers/i2c/busses/i2c-qcom-geni.c
@@ -1158,6 +1158,7 @@ static int geni_i2c_probe(struct platfor
 
 	ret = i2c_add_adapter(&gi2c->adap);
 	if (ret) {
+		release_gpi_dma(gi2c);
 		dev_err_probe(dev, ret, "Error adding i2c adapter\n");
 		pm_runtime_disable(gi2c->se.dev);
 		return ret;


