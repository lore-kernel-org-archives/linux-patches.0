Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78FBD531;
	Tue, 14 May 2024 11:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686131; cv=none; b=jq1z1gZZI6TyISk+ahkCGqc7vvrv97tiuGIw8QJo7qO/H7BS6v6WXHD1KCBu4sZTszeo80wzkSgmJxu8d37PNwaQVesxxdfG8NH1WlecnDnGy7VLEVlHNotC07wudT4u5wrmLBKn2vzTk0eKaIF9+AigpmrjRN6opnO++0AHb4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686131; c=relaxed/simple;
	bh=sUNFUjrJ+OmqpRohsmloIfW4CzyLCBThH2w+pQTqHM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BDTlxbLRub8WAZfgJKaqQjHEAabnITO9Xc+6VVbefaBFHRaNJf5JC4AWWsnQRNxwt7YYyVtxp2VVnhGP//AY/BUzNPESrAqOG/SD9qdDj3va2dWG440YgZgdFgvW0He9k/GLktUj0xd5WQSitwaTgI67990dK9oSgov9htxARgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L7cc/Bl7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L7cc/Bl7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD99C2BD10;
	Tue, 14 May 2024 11:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686130;
	bh=sUNFUjrJ+OmqpRohsmloIfW4CzyLCBThH2w+pQTqHM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L7cc/Bl7IEL+UCZX19B4fzqkTFTH8kJIMVm2cf8wrfdvq9LgqIXNbCZ5KRMs0VTo9
	 kRMuo6w6JGKdwZzxTAtmp/L/3777xbxUQv7lYicthSlM5S3BpG5oNX0LkeQnTxq4i2
	 jwHi6wdlKnEH3ZxWMq9lxohdma4ExIndERCdnpkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 031/236] pinctrl: Introduce struct pinfunction and PINCTRL_PINFUNCTION() macro
Date: Tue, 14 May 2024 12:16:33 +0200
Message-ID: <20240514101021.522992816@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 443a0a0f0cf4f432c7af6654b7f2f920d411d379 ]

There are many pin control drivers define their own data type for
pin function representation which is the same or embed the same data
as newly introduced one. Provide the data type and convenient macro
for all pin control drivers.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Stable-dep-of: fed6d9a8e6a6 ("pinctrl: baytrail: Fix selecting gpio pinctrl state")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pinctrl/pinctrl.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
index 487117ccb1bc2..fb25085d09224 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -206,6 +206,26 @@ extern int pinctrl_get_group_pins(struct pinctrl_dev *pctldev,
 				const char *pin_group, const unsigned **pins,
 				unsigned *num_pins);
 
+/**
+ * struct pinfunction - Description about a function
+ * @name: Name of the function
+ * @groups: An array of groups for this function
+ * @ngroups: Number of groups in @groups
+ */
+struct pinfunction {
+	const char *name;
+	const char * const *groups;
+	size_t ngroups;
+};
+
+/* Convenience macro to define a single named pinfunction */
+#define PINCTRL_PINFUNCTION(_name, _groups, _ngroups)	\
+(struct pinfunction) {					\
+		.name = (_name),			\
+		.groups = (_groups),			\
+		.ngroups = (_ngroups),			\
+	}
+
 #if IS_ENABLED(CONFIG_OF) && IS_ENABLED(CONFIG_PINCTRL)
 extern struct pinctrl_dev *of_pinctrl_get(struct device_node *np);
 #else
-- 
2.43.0



