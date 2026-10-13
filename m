Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28CD4EF13A;
	Tue, 13 Oct 2026 11:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892198; cv=none; b=RruxDfSxHNrk0OolynFvIfzrqDnC2xouh64KKJF1umd71lGhLMvRanJzK3H64OOltMLuxu1d2Ej26INt/xr6UtNN2wkP4MhWuma+lZzSQ2J8gPJN1q4gTKK7X9hZP8Ogva9b0TDJ/MIwbeTAMw4fpEnAjBvF/PxPn9H5tmZhKQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892198; c=relaxed/simple;
	bh=pQvPVUZbvIvil/zbmnQHKxNVnbhZ6yEV5UDUofF7YXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JW8V2sATOHT0+Z6yjAvqE+DVQETQW0zIhPWbgataMKZUO8DM4iokX+GdcYgdvm0G0fa3O2Vcwm31JGrH5hBEwHnqmUkbjLzCUd8N2Jt6GcZB0lX2k3AjqdrwejzKACsfVYZMAc26DyTmu6ASApXaGHSYly1olp1fJ2H2DY+EAxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZ22SnZf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZ22SnZf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375181F000FF;
	Tue, 13 Oct 2026 11:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892197;
	bh=35mC5/WUcnK4ffdp2l8eezh4TgmUnmup6ljgCn9juwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XZ22SnZfIr7cdEW0k4XtCMokPKH2i/KWYmv8+hlatw3AjkDOe/2JsyFXcxes/py+w
	 6VHl0gjdJwfnXcAxzu6bLiK3S5ikL63IOhkwwnaap8okbxDMzJr9nIC5S8Ft8I4KwT
	 Os0rzRSpG82NeGREaH3aSLpVCAdGDrcRxwSaNVY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Charkov <alchark@flipper.net>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.2 094/281] power: sequencing: pcie-m2: Fix leaking array from of_regulator_bulk_get_all()
Date: Tue, 13 Oct 2026 13:36:50 +0200
Message-ID: <20261013112857.417552096@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Alexey Charkov <alchark@flipper.net>

commit 0d6c5794fd633427f0d4ad8b51d94061295649da upstream.

of_regulator_bulk_get_all() allocates the consumers array and hands it to
the caller, who is expected to free it at an appropriate time.
pwrseq-pcie-m2.c never did, leading to a memory leak.

Add an explicit kfree() for the consumers array.

Cc: stable@vger.kernel.org
Fixes: 52e7b5bd62ba ("power: sequencing: Add the Power Sequencing driver for the PCIe M.2 connectors")
Signed-off-by: Alexey Charkov <alchark@flipper.net>
Link: https://patch.msgid.link/20260930-m2-pwrseq-kfree-v1-1-82678b02c126@flipper.net
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/sequencing/pwrseq-pcie-m2.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/power/sequencing/pwrseq-pcie-m2.c
+++ b/drivers/power/sequencing/pwrseq-pcie-m2.c
@@ -562,6 +562,7 @@ err_destroy_mutex:
 	mutex_destroy(&ctx->list_lock);
 err_free_regulators:
 	regulator_bulk_free(ctx->num_vregs, ctx->regs);
+	kfree(ctx->regs);
 
 	return ret;
 }
@@ -575,6 +576,7 @@ static void pwrseq_pcie_m2_remove(struct
 	mutex_destroy(&ctx->list_lock);
 
 	regulator_bulk_free(ctx->num_vregs, ctx->regs);
+	kfree(ctx->regs);
 }
 
 static const struct of_device_id pwrseq_pcie_m2_of_match[] = {


