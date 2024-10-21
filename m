Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2931E8854;
	Mon, 21 Oct 2024 10:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506791; cv=none; b=bWd2pgZnwLSgoI6UxV81a89LRfzYoR0nzFXqLV7vzMtMAyKTCb1WRvDHVAeH0xDhCy+SdU23acepG8W+PmppbQh/B+0/crblmVfMG45UBFBlDBPqIhvp3dTG76+uc96AmJ14vAWeCkNk5m7xIDNrlT3YXhWFvdGcHv3wAbmSUuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506791; c=relaxed/simple;
	bh=DiLtWdQIRdZK6sLt5Q/QEPVQURMUiRQU8c+xsi59Akc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FWsCEAQ4bfa2wcOqHH5f6bOTFrrPfKgbkghe4cvZFaLtoN65LBm7W/a7JTaMA2c3xhmBYA0srJeYCZd0GuVwV+oQps2vHNVIFvVlBhgf0eWZaz+Fskksu2liB/kD+b1+fl02UJb6+119jrYj2pDnbM8o29kBLUNmiG0yXRjvWZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bNhti0Ag; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bNhti0Ag"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC35C4CEC3;
	Mon, 21 Oct 2024 10:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506790;
	bh=DiLtWdQIRdZK6sLt5Q/QEPVQURMUiRQU8c+xsi59Akc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bNhti0AgQGKKv68fr6LkfxJAAJsFD6W0dRNd/yZERZHoqSzhSJsRihd2N+PFq9pJJ
	 FViQ/JIHoWtz9pSTf+R3x3LXdETmkqZ9tEqdVgy7QvI58oOm2J05mCqAq5DgXdT4LI
	 9e7JNSyvVhLZhQQH7ZUo/JfAAdO3s3CpQA1cqazk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.11 122/135] pinctrl: intel: platform: fix error path in device_for_each_child_node()
Date: Mon, 21 Oct 2024 12:24:38 +0200
Message-ID: <20241021102304.106920060@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 16a6d2e685e8f9a2f51dd5a363d3f97fcad35e22 upstream.

The device_for_each_child_node() loop requires calls to
fwnode_handle_put() upon early returns to decrement the refcount of
the child node and avoid leaking memory if that error path is triggered.

There is one early returns within that loop in
intel_platform_pinctrl_prepare_community(), but fwnode_handle_put() is
missing.

Instead of adding the missing call, the scoped version of the loop can
be used to simplify the code and avoid mistakes in the future if new
early returns are added, as the child node is only used for parsing, and
it is never assigned.

Cc: stable@vger.kernel.org
Fixes: c5860e4a2737 ("pinctrl: intel: Add a generic Intel pin control platform driver")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/intel/pinctrl-intel-platform.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/pinctrl/intel/pinctrl-intel-platform.c
+++ b/drivers/pinctrl/intel/pinctrl-intel-platform.c
@@ -90,7 +90,6 @@ static int intel_platform_pinctrl_prepar
 						    struct intel_community *community,
 						    struct intel_platform_pins *pins)
 {
-	struct fwnode_handle *child;
 	struct intel_padgroup *gpps;
 	unsigned int group;
 	size_t ngpps;
@@ -131,7 +130,7 @@ static int intel_platform_pinctrl_prepar
 		return -ENOMEM;
 
 	group = 0;
-	device_for_each_child_node(dev, child) {
+	device_for_each_child_node_scoped(dev, child) {
 		struct intel_padgroup *gpp = &gpps[group];
 
 		gpp->reg_num = group;


