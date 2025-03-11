Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A120A25D8FF;
	Tue, 11 Mar 2025 15:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705918; cv=none; b=jqockUDX294rrD6rew8NVltWmYAR/Q9pwOucp9xw2VxgwvjZuGRo6sJAMdRUHdlxBvzWRidnOCfoGhbEf7v4zJ2JcrGkrHNTAnxlGghG155BXrHdcwXjGsUA3OcH/U2MRSbD4W79UTyadp/YJQLcmd25ROBJYJKQuG4uZhp+RNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705918; c=relaxed/simple;
	bh=e0YUtL9GfPOHxDaO/aWlxmJLgrwCx+lBb08SsmbHTI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDoaVb/kJTZQJW70NbEaVSuVzFFPXKku3bzA4Ug4AAabhQpdV2vnDUsYpM0+uuF360SetECCq5meg0Cih8A+zz6Vw3dk9JactlRkGDrToAf2kKsntmbMp0weyMc9yq06m/ZX9tw+qcs+GGIQ4JUuPVZYVtUvHBNzypU/EYTVKYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KZZG6pKt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KZZG6pKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2223C4CEE9;
	Tue, 11 Mar 2025 15:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705918;
	bh=e0YUtL9GfPOHxDaO/aWlxmJLgrwCx+lBb08SsmbHTI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KZZG6pKtwlnVy4dPMIDGd4HL3bkofBtsJy+WXUH/7OlggqSaVl9veqgR5whUcNBSG
	 6JQjZyEMIyaSJL9t6Eo7AjjRlqp5RLg+AU5Lk6zk4dBO3OqTYmIjLh388i7qt4ly32
	 Vny76Aoc7pn2BT3bQ5THAkzImkLCMUWIRchxmKwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 200/328] regmap-irq: Add missing kfree()
Date: Tue, 11 Mar 2025 15:59:30 +0100
Message-ID: <20250311145722.851894036@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

commit 32ffed055dcee17f6705f545b069e44a66067808 upstream.

Add kfree() for "d->main_status_buf" to the error-handling path to prevent
a memory leak.

Fixes: a2d21848d921 ("regmap: regmap-irq: Add main status register support")
Cc: stable@vger.kernel.org  # v5.1+
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Link: https://patch.msgid.link/20250205004343.14413-1-jiashengjiangcool@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/regmap/regmap-irq.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -808,6 +808,7 @@ err_alloc:
 	kfree(d->wake_buf);
 	kfree(d->mask_buf_def);
 	kfree(d->mask_buf);
+	kfree(d->main_status_buf);
 	kfree(d->status_buf);
 	kfree(d->status_reg_buf);
 	kfree(d);
@@ -854,6 +855,7 @@ void regmap_del_irq_chip(int irq, struct
 	kfree(d->wake_buf);
 	kfree(d->mask_buf_def);
 	kfree(d->mask_buf);
+	kfree(d->main_status_buf);
 	kfree(d->status_reg_buf);
 	kfree(d->status_buf);
 	kfree(d);


