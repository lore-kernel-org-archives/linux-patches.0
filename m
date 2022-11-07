Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C18515C95
	for <patches@lists.linux.dev>; Mon,  7 Nov 2022 22:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667861687; x=1699397687;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pUDmXJ81hZPKLSigWUAhVkXDqINWawcz+Tl9WL2UD/A=;
  b=IAuN9j88FSFN4JFpY4gHozcqWPtm5t0XGKXf6qZs0iX63QddulQPjwe4
   aI6vSMSHtdXCvP82UbpPSjNwKqQV6TkV5cglNV4bLrRXRifOlUVStY2qD
   YpWeIM3wymTzUvEhC8J2t/Kt+WRyYhxjpdDs3UZ1hbcAQ2QGf4MGd65qC
   o9SPQxqc3EY+94ipoHDQNpGur34xD7uEH50yBDi/SBWEasTMb7Vfrg2LP
   EyZoSNmJYN14oMkVwd0F4k1kwHNQN/TZ88Xaz92EJCEKpDJl82KFiFemA
   PKamTW0HmcfWRLGgDWbS4fznA42DVwqXaAcI5l0dXz8vt5QcKe1WHagZ9
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="311697391"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="311697391"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 14:54:45 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="811012955"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="811012955"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 14:54:45 -0800
From: Jithu Joseph <jithu.joseph@intel.com>
To: hdegoede@redhat.com,
	markgross@kernel.org
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	gregkh@linuxfoundation.org,
	jithu.joseph@intel.com,
	ashok.raj@intel.com,
	tony.luck@intel.com,
	linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	ravi.v.shankar@intel.com,
	thiago.macieira@intel.com,
	athenas.jimenez.gonzalez@intel.com,
	sohil.mehta@intel.com
Subject: [PATCH v2 02/14] platform/x86/intel/ifs: return a more appropriate Error code
Date: Mon,  7 Nov 2022 14:53:11 -0800
Message-Id: <20221107225323.2733518-3-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221107225323.2733518-1-jithu.joseph@intel.com>
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
 <20221107225323.2733518-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

scan_chunks_sanity_check() returns -ENOMEM if it encounters
an error while copying IFS test image from memory to Secure Memory.

Return -EIO in this scenario, as it is more appropriate.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
---
 drivers/platform/x86/intel/ifs/load.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
index d056617ddc85..89ce265887ea 100644
--- a/drivers/platform/x86/intel/ifs/load.c
+++ b/drivers/platform/x86/intel/ifs/load.c
@@ -157,8 +157,10 @@ static int scan_chunks_sanity_check(struct device *dev)
 		INIT_WORK(&local_work.w, copy_hashes_authenticate_chunks);
 		schedule_work_on(cpu, &local_work.w);
 		wait_for_completion(&ifs_done);
-		if (ifsd->loading_error)
+		if (ifsd->loading_error) {
+			ret = -EIO;
 			goto out;
+		}
 		package_authenticated[curr_pkg] = 1;
 	}
 	ret = 0;
-- 
2.25.1

