Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3D17C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D97C433D2;
	Mon, 24 Apr 2023 13:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343077;
	bh=8M/LCCMRDH4FXHIQ8fIJC+eRJ1ubq/crP4lyDGdMpr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iq5OintsKSM+66M1/9R+G6YyzPGo8O9m5EsDbr1ZGzHolo4jrsTQryEorBzYQw6H6
	 kOQgroKHl2Jw/lHvA10SZr9rCxfyGSkAjkDStzdoI4hW5/CH8ZT4qZGonNZKql4Qwa
	 w4TAd+SBQWOXWhRci1iiEVhamB/gp96q/pypILYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David E. Box" <david.e.box@linux.intel.com>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 039/110] platform/x86/intel: vsec: Fix a memory leak in intel_vsec_add_aux
Date: Mon, 24 Apr 2023 15:17:01 +0200
Message-Id: <20230424131137.616055800@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dongliang Mu <dzm91@hust.edu.cn>

[ Upstream commit da0ba0ccce54059d6c6b788a75099bfce95126da ]

The first error handling code in intel_vsec_add_aux misses the
deallocation of intel_vsec_dev->resource.

Fix this by adding kfree(intel_vsec_dev->resource) in the error handling
code.

Reviewed-by: David E. Box <david.e.box@linux.intel.com>
Signed-off-by: Dongliang Mu <dzm91@hust.edu.cn>
Link: https://lore.kernel.org/r/20230309040107.534716-4-dzm91@hust.edu.cn
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/vsec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/intel/vsec.c b/drivers/platform/x86/intel/vsec.c
index 89c5374e33b32..bcbd522d062bf 100644
--- a/drivers/platform/x86/intel/vsec.c
+++ b/drivers/platform/x86/intel/vsec.c
@@ -141,6 +141,7 @@ static int intel_vsec_add_aux(struct pci_dev *pdev, struct intel_vsec_device *in
 
 	ret = ida_alloc(intel_vsec_dev->ida, GFP_KERNEL);
 	if (ret < 0) {
+		kfree(intel_vsec_dev->resource);
 		kfree(intel_vsec_dev);
 		return ret;
 	}
-- 
2.39.2



