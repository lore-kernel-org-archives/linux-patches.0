Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0713514389D;
	Tue, 23 Apr 2024 21:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908625; cv=none; b=lZIm0y9kVgp/h4lpg+IfK82YW/EalwRde+lL3FH5Z1L31zy6u0zAYAIJlRkqjV9qAX7buw2klXdwOUXyEfL2cN74ODBhX9iurm8LE5p/RF/8dnIer6EwIms95l7s/yc7XtEckqArJASJeWU/fERFeiIaPEwZSdotdaWmWCgy8NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908625; c=relaxed/simple;
	bh=9zvfNdRT41A+03/XLggV0ITb/R4Y+xajNZ6brrpaoLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxhbwe1F9yWfZrCWK4wc3bEw70gGijs/1ojbCzfERk4VaGoLB6N6nnd/7i6vuNvMUBolGqOPQLtIDJYWzRjQAiDGZ8UsxIlEno3CaQoeVSLr2oo/JqDvTAS9//4Z6i10ghqJ30Yh0Ouq2UA+dEXlg5/AuJ04+bTYfF09a3Xk53U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZFt2+kBk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZFt2+kBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B843AC116B1;
	Tue, 23 Apr 2024 21:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908624;
	bh=9zvfNdRT41A+03/XLggV0ITb/R4Y+xajNZ6brrpaoLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZFt2+kBkW5LZ4f2GJCL3jFBOGby6ht64RFKXYXtU8V1iuVBaHbRvQAqvRcIF2Whou
	 u4VzgZn4ZwErSMz7KBO3R2SetAFGKBvqCYI5XLrN2QkCMfTiMoLar8ZpndZ7y/hkHt
	 0oEkSieUxLLeLFsr+m6KvlbpdP/3mlpCEZXbwjq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanath S <Sanath.S@amd.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.6 076/158] thunderbolt: Introduce tb_path_deactivate_hop()
Date: Tue, 23 Apr 2024 14:38:33 -0700
Message-ID: <20240423213858.236559330@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

From: Sanath S <Sanath.S@amd.com>

commit b35c1d7b11da8c08b14147bbe87c2c92f7a83f8b upstream.

This function can be used to clear path config space of an adapter. Make
it available for other files in this driver.

Signed-off-by: Sanath S <Sanath.S@amd.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/path.c |   13 +++++++++++++
 drivers/thunderbolt/tb.h   |    1 +
 2 files changed, 14 insertions(+)

--- a/drivers/thunderbolt/path.c
+++ b/drivers/thunderbolt/path.c
@@ -446,6 +446,19 @@ static int __tb_path_deactivate_hop(stru
 	return -ETIMEDOUT;
 }
 
+/**
+ * tb_path_deactivate_hop() - Deactivate one path in path config space
+ * @port: Lane or protocol adapter
+ * @hop_index: HopID of the path to be cleared
+ *
+ * This deactivates or clears a single path config space entry at
+ * @hop_index. Returns %0 in success and negative errno otherwise.
+ */
+int tb_path_deactivate_hop(struct tb_port *port, int hop_index)
+{
+	return __tb_path_deactivate_hop(port, hop_index, true);
+}
+
 static void __tb_path_deactivate_hops(struct tb_path *path, int first_hop)
 {
 	int i, res;
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -1100,6 +1100,7 @@ struct tb_path *tb_path_alloc(struct tb
 void tb_path_free(struct tb_path *path);
 int tb_path_activate(struct tb_path *path);
 void tb_path_deactivate(struct tb_path *path);
+int tb_path_deactivate_hop(struct tb_port *port, int hop_index);
 bool tb_path_is_invalid(struct tb_path *path);
 bool tb_path_port_on_path(const struct tb_path *path,
 			  const struct tb_port *port);


