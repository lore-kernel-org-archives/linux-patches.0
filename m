Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1A12E1C74;
	Tue,  8 Jul 2025 16:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993832; cv=none; b=euOXWckUjXa34NGTlb7Rw43Rwts3yZD7yfVCh6Ut30HO3cuclPzmIwO0tyHkqlVGyg3PH/hZAIe6VzpwuLUusYMmeN1PJUiiVznU8OWA+WE0T9MFKe/qn7W8V0F0T6hVMfqA01mkjRQmnAJ/bHA3Y3swc6IsUcTgYO43WWOk0ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993832; c=relaxed/simple;
	bh=GtFB/b2JZ5ciHqUpE+Z226qa8O6ihuqP9XbNEifmJaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DnPevxRq5gP7ah6x/FE0NBW3k2ZBMXUg/37i89H8FdWxR26DKTs2k3tpw+/8J7spcxFRSDGG8/jCwrcOZpc3MmWQ/n4+eH+bpN6QZAd1WP6epkEoHFaX82wW5EBfG3ESSu9fnGESij9GMUpZXKDAnKtexgnzlwhOQwOhOP//PxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V5yYAs+q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V5yYAs+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A5FC4CEED;
	Tue,  8 Jul 2025 16:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993832;
	bh=GtFB/b2JZ5ciHqUpE+Z226qa8O6ihuqP9XbNEifmJaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V5yYAs+qQKap42kqYvFPcuS6V0Vhg2CzbabN8q4qppss/R6EHEbkalKZFE2Jd1x9b
	 +xRWMGA7tPaIIwcUvbxCOvzlZ8QXQ4aAoc6T7IguVp+TyaRpP+zAWpP/DA+53Narnk
	 lQSEGLq1uEPJ893P5ALk1t56SV8cRiBfTSpXq0Bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/160] regulator: core: Allow drivers to define their init data as const
Date: Tue,  8 Jul 2025 18:21:10 +0200
Message-ID: <20250708162232.443838915@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 1de452a0edda26f1483d1d934f692eab13ba669a ]

Drivers tend to want to define the names of their regulators somewhere
in their source file as "static const". This means, inevitable, that
every driver out there open codes something like this:

static const char * const supply_names[] = {
 "vcc", "vccl",
};

static int get_regulators(struct my_data *data)
{
  int i;

  data->supplies = devm_kzalloc(...)
  if (!data->supplies)
    return -ENOMEM;

  for (i = 0; i < ARRAY_SIZE(supply_names); i++)
    data->supplies[i].supply = supply_names[i];

  return devm_regulator_bulk_get(data->dev,
                                 ARRAY_SIZE(supply_names),
				 data->supplies);
}

Let's make this more convenient by doing providing a helper that does
the copy.

I have chosen to have the "const" input structure here be the exact
same structure as the normal one passed to
devm_regulator_bulk_get(). This is slightly inefficent since the input
data can't possibly have anything useful for "ret" or consumer and
thus we waste 8 bytes per structure. This seems an OK tradeoff for not
introducing an extra structure.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20220726103631.v2.6.I38fc508a73135a5c1b873851f3553ff2a3a625f5@changeid
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 9079db287fc3 ("ASoC: codecs: wcd9335: Fix missing free of regulator supplies")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/devres.c         | 28 ++++++++++++++++++++++++++++
 include/linux/regulator/consumer.h |  4 ++++
 2 files changed, 32 insertions(+)

diff --git a/drivers/regulator/devres.c b/drivers/regulator/devres.c
index 9113233f41cd1..32823a87fd409 100644
--- a/drivers/regulator/devres.c
+++ b/drivers/regulator/devres.c
@@ -166,6 +166,34 @@ int devm_regulator_bulk_get(struct device *dev, int num_consumers,
 }
 EXPORT_SYMBOL_GPL(devm_regulator_bulk_get);
 
+/**
+ * devm_regulator_bulk_get_const - devm_regulator_bulk_get() w/ const data
+ *
+ * @dev:           device to supply
+ * @num_consumers: number of consumers to register
+ * @in_consumers:  const configuration of consumers
+ * @out_consumers: in_consumers is copied here and this is passed to
+ *		   devm_regulator_bulk_get().
+ *
+ * This is a convenience function to allow bulk regulator configuration
+ * to be stored "static const" in files.
+ *
+ * Return: 0 on success, an errno on failure.
+ */
+int devm_regulator_bulk_get_const(struct device *dev, int num_consumers,
+				  const struct regulator_bulk_data *in_consumers,
+				  struct regulator_bulk_data **out_consumers)
+{
+	*out_consumers = devm_kmemdup(dev, in_consumers,
+				      num_consumers * sizeof(*in_consumers),
+				      GFP_KERNEL);
+	if (*out_consumers == NULL)
+		return -ENOMEM;
+
+	return devm_regulator_bulk_get(dev, num_consumers, *out_consumers);
+}
+EXPORT_SYMBOL_GPL(devm_regulator_bulk_get_const);
+
 static void devm_rdev_release(struct device *dev, void *res)
 {
 	regulator_unregister(*(struct regulator_dev **)res);
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index bbf6590a6dec2..61f922e6fe353 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -240,6 +240,10 @@ int __must_check regulator_bulk_get(struct device *dev, int num_consumers,
 				    struct regulator_bulk_data *consumers);
 int __must_check devm_regulator_bulk_get(struct device *dev, int num_consumers,
 					 struct regulator_bulk_data *consumers);
+int __must_check devm_regulator_bulk_get_const(
+	struct device *dev, int num_consumers,
+	const struct regulator_bulk_data *in_consumers,
+	struct regulator_bulk_data **out_consumers);
 int __must_check regulator_bulk_enable(int num_consumers,
 				       struct regulator_bulk_data *consumers);
 int regulator_bulk_disable(int num_consumers,
-- 
2.39.5



