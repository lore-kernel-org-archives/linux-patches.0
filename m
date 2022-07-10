Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B33D1C17
	for <patches@lists.linux.dev>; Sun, 10 Jul 2022 18:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657477529; x=1689013529;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5y4vwrb2+7xCrIUmxJiHnlCdSDFJBBSO+45IgJpkgxw=;
  b=aoiVwBu0gDtFJoIRCIoWpXpn44kHy0AqAiA04gdXx1CwsQi5OwrHF3sd
   yNFUp0Sqo4g5NhftyVAj6Z4Q+tCBr37itBQknFu7gqQpW3/vlVH9rbdGr
   1wNi+Klz5aAvx+oxADpil9G0eFj+mxzuGjeAG87MPqON4ugr2eG9tQvZm
   +wIUkr5LIIfEJ7aWQXZVtPOnGjGoZTFi2cC1//W9ooUQvoiDoEL2nOMu5
   RYGz28wlOUJbHh1dgnBaFXLS9LgO8/tNC5Hgj516xDvww19XQxBiE4V5P
   sAiSf2hDhhSfLF8h4bPjYZjQZkrjTJNjusNPkRDqcmwSl3Msiwk4fiHuN
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="267572507"
X-IronPort-AV: E=Sophos;i="5.92,261,1650956400"; 
   d="scan'208";a="267572507"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2022 11:25:26 -0700
X-IronPort-AV: E=Sophos;i="5.92,261,1650956400"; 
   d="scan'208";a="736864833"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2022 11:25:26 -0700
From: Tony Luck <tony.luck@intel.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	"Joseph, Jithu" <jithu.joseph@intel.com>,
	markgross@kernel.org,
	ashok.raj@intel.com,
	ravi.v.shankar@intel.com,
	linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 2/2] platform/x86/intel/ifs: return error on load failure
Date: Sun, 10 Jul 2022 11:25:21 -0700
Message-Id: <20220710182521.60642-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220710182521.60642-1-tony.luck@intel.com>
References: <c416b93b-8adc-d9a8-ef0d-594cce6d9a9d@redhat.com>
 <20220710182521.60642-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jithu Joseph <jithu.joseph@intel.com>

A bug in ifs_load_firmware() error path will make it return
SUCCESS in the event of failure.

If ifs_image_sanity_check() fails, then "ret" is still zero (from
the earlier successful call to request_firmware_direct().

Reinitialize the return variable with appropriate error code.

Fixes: 684ec215706d4 ("platform/x86/intel/ifs: Authenticate and copy to secured memory")
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/platform/x86/intel/ifs/load.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
index d056617ddc85..3edcc570f1fe 100644
--- a/drivers/platform/x86/intel/ifs/load.c
+++ b/drivers/platform/x86/intel/ifs/load.c
@@ -252,6 +252,7 @@ void ifs_load_firmware(struct device *dev)
 
 	if (!ifs_image_sanity_check(dev, (struct microcode_header_intel *)fw->data)) {
 		dev_err(dev, "ifs header sanity check failed\n");
+		ret = -EINVAL;
 		goto release;
 	}
 
-- 
2.35.3

