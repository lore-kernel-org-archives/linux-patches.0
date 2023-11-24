Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D3B381D4;
	Fri, 24 Nov 2023 18:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A1HtBBBa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08AC0C433C8;
	Fri, 24 Nov 2023 18:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849419;
	bh=2GWgreo128ZMDvAQqoyEh+pCcNBh/yjPyHADNw8dtgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A1HtBBBaMGkuh9kaw1OT0dd7GOji8DOHyt8o8v8p741vd7NSw6GYgFEuSov8rqlKZ
	 1SQAiYQXLHq0/4xMWvcZrIS12Q2vDh0RhxlkBQpdPCFvIvfqz6e+fGUVqHyaKSyLGX
	 QJsvHFeX2UXF5aw7kEBpFvrrPu/veRQRPz5+MFQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Kahola <mika.kahola@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 174/530] drm/i915/tc: Fix -Wformat-truncation in intel_tc_port_init
Date: Fri, 24 Nov 2023 17:45:40 +0000
Message-ID: <20231124172033.371602125@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nirmoy Das <nirmoy.das@intel.com>

[ Upstream commit 9506fba463fcbdf8c8b7af3ec9ee34360df843fe ]

Fix below compiler warning:

intel_tc.c:1879:11: error: ‘%d’ directive output may be truncated
writing between 1 and 11 bytes into a region of size 3
[-Werror=format-truncation=]
"%c/TC#%d", port_name(port), tc_port + 1);
           ^~
intel_tc.c:1878:2: note: ‘snprintf’ output between 7 and 17 bytes
into a destination of size 8
  snprintf(tc->port_name, sizeof(tc->port_name),
  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    "%c/TC#%d", port_name(port), tc_port + 1);
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

v2: use kasprintf(Imre)
v3: use const for port_name, and fix tc mem leak(Imre)

Fixes: 3eafcddf766b ("drm/i915/tc: Move TC port fields to a new intel_tc_port struct")
Cc: Mika Kahola <mika.kahola@intel.com>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Reviewed-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Mika Kahola <mika.kahola@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231026125636.5080-1-nirmoy.das@intel.com
(cherry picked from commit 70a3cbbe620ee66afb0c066624196077767e61b2)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_tc.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_tc.c b/drivers/gpu/drm/i915/display/intel_tc.c
index 3ebf41859043e..cdf2455440bea 100644
--- a/drivers/gpu/drm/i915/display/intel_tc.c
+++ b/drivers/gpu/drm/i915/display/intel_tc.c
@@ -58,7 +58,7 @@ struct intel_tc_port {
 	struct delayed_work link_reset_work;
 	int link_refcount;
 	bool legacy_port:1;
-	char port_name[8];
+	const char *port_name;
 	enum tc_port_mode mode;
 	enum tc_port_mode init_mode;
 	enum phy_fia phy_fia;
@@ -1841,8 +1841,12 @@ int intel_tc_port_init(struct intel_digital_port *dig_port, bool is_legacy)
 	else
 		tc->phy_ops = &icl_tc_phy_ops;
 
-	snprintf(tc->port_name, sizeof(tc->port_name),
-		 "%c/TC#%d", port_name(port), tc_port + 1);
+	tc->port_name = kasprintf(GFP_KERNEL, "%c/TC#%d", port_name(port),
+				  tc_port + 1);
+	if (!tc->port_name) {
+		kfree(tc);
+		return -ENOMEM;
+	}
 
 	mutex_init(&tc->lock);
 	/* TODO: Combine the two works */
@@ -1863,6 +1867,7 @@ void intel_tc_port_cleanup(struct intel_digital_port *dig_port)
 {
 	intel_tc_port_suspend(dig_port);
 
+	kfree(dig_port->tc->port_name);
 	kfree(dig_port->tc);
 	dig_port->tc = NULL;
 }
-- 
2.42.0



