Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3CE633
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:42:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7761DC433C1;
	Wed,  2 Nov 2022 03:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667360542;
	bh=w9slgkLfVOr7zVtlTELdGQAGtKWpbN5hGGz+qeElP6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yOI7FLhTb3TedZEdNlkBbLQWL/PzMd+Yd3aa72Hyw4vrvMi5CqvMSIohblylb2vkE
	 OAFEKrEgxDREurKFtdEWLED1LqiP3136uhik++Lv9UGvpQfVvBUkfLT6vlyqCPCPr/
	 Xg9e3TZLlX7qPYaFWqBSYYKolgRXn5EcTsyI5l5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@arm.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 55/60] PM: domains: Fix handling of unavailable/disabled idle states
Date: Wed,  2 Nov 2022 03:35:16 +0100
Message-Id: <20221102022052.882935373@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022051.081761052@linuxfoundation.org>
References: <20221102022051.081761052@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit e0c57a5c70c13317238cb19a7ded0eab4a5f7de5 ]

Platforms can provide the information about the availability of each
idle states via status flag. Platforms may have to disable one or more
idle states for various reasons like broken firmware or other unmet
dependencies.

Fix handling of such unavailable/disabled idle states by ignoring them
while parsing the states.

Fixes: a3381e3a65cb ("PM / domains: Fix up domain-idle-states OF parsing")
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/domain.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index e811f2414889..a64b093a88cf 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -2232,6 +2232,10 @@ static int genpd_iterate_idle_states(struct device_node *dn,
 		np = it.node;
 		if (!of_match_node(idle_state_match, np))
 			continue;
+
+		if (!of_device_is_available(np))
+			continue;
+
 		if (states) {
 			ret = genpd_parse_state(&states[i], np);
 			if (ret) {
-- 
2.35.1



