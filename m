Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7621813D896;
	Tue, 23 Jul 2024 18:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759641; cv=none; b=Ac6Q/CC6zcQK7tW2vfYkJfzofQjK/2Pj0MqIdtJCWYXSlnjv/IMq0Yb0T1vCugQrmGQw3xssx1Rzs4PudHO/GZWBGDLY3xpaqL3AgDIF8fnm5Q8xGDi/rngWFwyJue0Zztsh1veZA2MqeFj4y9GIiRj8WYtY2Fp4swsHP0AVDxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759641; c=relaxed/simple;
	bh=zvbUr2g6bz+x+nJW+8wP3FBw9ewjELBGRqGnV95726U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=umYD9H6u2y7xExDGepeZ5IBSchMhqqv+6/RDVg6oRRQe8OxhF7L97+RrqFqYfpoLUo8XzNf2500DWOrlKgUM20eHj7Na8U738U2LEddzTH4cz4BB29nMCvwczFN+mn0VGUruz9dJtVm56AX8Yj+CHtbjQ2yIA6FYxvj/Hhu6tYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l4wA9mrk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l4wA9mrk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F4CC4AF0A;
	Tue, 23 Jul 2024 18:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759641;
	bh=zvbUr2g6bz+x+nJW+8wP3FBw9ewjELBGRqGnV95726U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l4wA9mrkHOC7D/yajA2wxaSXLVaMja8DY1bBBTBG2n8cQcly6bze458NenIWYqJDz
	 d1GGbgt12V7NvtZePR3zinlUNF6oVnIOD8vuJbdrBSoQeA+4WbMDVBcYIe4jVScTCs
	 eEzD93Yzlr8W0R5ePPpunZVH7YH5YcIhHhLKER5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Ray <ian.ray@gehealthcare.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 078/129] gpio: pca953x: fix pca953x_irq_bus_sync_unlock race
Date: Tue, 23 Jul 2024 20:23:46 +0200
Message-ID: <20240723180407.797083239@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

From: Ian Ray <ian.ray@gehealthcare.com>

[ Upstream commit bfc6444b57dc7186b6acc964705d7516cbaf3904 ]

Ensure that `i2c_lock' is held when setting interrupt latch and mask in
pca953x_irq_bus_sync_unlock() in order to avoid races.

The other (non-probe) call site pca953x_gpio_set_multiple() ensures the
lock is held before calling pca953x_write_regs().

The problem occurred when a request raced against irq_bus_sync_unlock()
approximately once per thousand reboots on an i.MX8MP based system.

 * Normal case

   0-0022: write register AI|3a {03,02,00,00,01} Input latch P0
   0-0022: write register AI|49 {fc,fd,ff,ff,fe} Interrupt mask P0
   0-0022: write register AI|08 {ff,00,00,00,00} Output P3
   0-0022: write register AI|12 {fc,00,00,00,00} Config P3

 * Race case

   0-0022: write register AI|08 {ff,00,00,00,00} Output P3
   0-0022: write register AI|08 {03,02,00,00,01} *** Wrong register ***
   0-0022: write register AI|12 {fc,00,00,00,00} Config P3
   0-0022: write register AI|49 {fc,fd,ff,ff,fe} Interrupt mask P0

Signed-off-by: Ian Ray <ian.ray@gehealthcare.com>
Link: https://lore.kernel.org/r/20240620042915.2173-1-ian.ray@gehealthcare.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index bdd50a78e4142..ce9a94e332801 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -766,6 +766,8 @@ static void pca953x_irq_bus_sync_unlock(struct irq_data *d)
 	int level;
 
 	if (chip->driver_data & PCA_PCAL) {
+		guard(mutex)(&chip->i2c_lock);
+
 		/* Enable latch on interrupt-enabled inputs */
 		pca953x_write_regs(chip, PCAL953X_IN_LATCH, chip->irq_mask);
 
-- 
2.43.0



