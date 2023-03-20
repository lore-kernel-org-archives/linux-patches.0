Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C7F1C32
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D31C433D2;
	Mon, 20 Mar 2023 15:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679326205;
	bh=eii+HW//q40cWz/ofqupX/SE2zqO4kd8s18Jb7fb00k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SI4ZSwebx94uMCTGc6/r/WpUPZK6I8g2hToPp7KBkbL0kTOTmnhn6H0Bzofo3NsZI
	 tPH7wMlmTKHKh8XfjaChOwoEEZIwv45wVG6pZJv7ofytsLe6dAom2efJrS1DCnPQxu
	 XMhnZz5eOoJEtTjPqoVqCLxHqIMzpjH4L3gnQV2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@arm.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Shawn Guo <shawn.guo@linaro.org>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: [PATCH 6.2 198/211] cpuidle: psci: Iterate backwards over list in psci_pd_remove()
Date: Mon, 20 Mar 2023 15:55:33 +0100
Message-Id: <20230320145521.828048686@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shawn Guo <shawn.guo@linaro.org>

commit 6b0313c2fa3d2cf991c9ffef6fae6e7ef592ce6d upstream.

In case that psci_pd_init_topology() fails for some reason,
psci_pd_remove() will be responsible for deleting provider and removing
genpd from psci_pd_providers list.  There will be a failure when removing
the cluster PD, because the cpu (child) PDs haven't been removed.

[    0.050232] CPUidle PSCI: init PM domain cpu0
[    0.050278] CPUidle PSCI: init PM domain cpu1
[    0.050329] CPUidle PSCI: init PM domain cpu2
[    0.050370] CPUidle PSCI: init PM domain cpu3
[    0.050422] CPUidle PSCI: init PM domain cpu-cluster0
[    0.050475] PM: genpd_remove: unable to remove cpu-cluster0
[    0.051412] PM: genpd_remove: removed cpu3
[    0.051449] PM: genpd_remove: removed cpu2
[    0.051499] PM: genpd_remove: removed cpu1
[    0.051546] PM: genpd_remove: removed cpu0

Fix the problem by iterating the provider list reversely, so that parent
PD gets removed after child's PDs like below.

[    0.029052] CPUidle PSCI: init PM domain cpu0
[    0.029076] CPUidle PSCI: init PM domain cpu1
[    0.029103] CPUidle PSCI: init PM domain cpu2
[    0.029124] CPUidle PSCI: init PM domain cpu3
[    0.029151] CPUidle PSCI: init PM domain cpu-cluster0
[    0.029647] PM: genpd_remove: removed cpu0
[    0.029666] PM: genpd_remove: removed cpu1
[    0.029690] PM: genpd_remove: removed cpu2
[    0.029714] PM: genpd_remove: removed cpu3
[    0.029738] PM: genpd_remove: removed cpu-cluster0

Fixes: a65a397f2451 ("cpuidle: psci: Add support for PM domains by using genpd")
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Cc: 5.10+ <stable@vger.kernel.org> # 5.10+
Signed-off-by: Rafael J. Wysocki <rjw@rjwysocki.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpuidle/cpuidle-psci-domain.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/cpuidle/cpuidle-psci-domain.c
+++ b/drivers/cpuidle/cpuidle-psci-domain.c
@@ -103,7 +103,8 @@ static void psci_pd_remove(void)
 	struct psci_pd_provider *pd_provider, *it;
 	struct generic_pm_domain *genpd;
 
-	list_for_each_entry_safe(pd_provider, it, &psci_pd_providers, link) {
+	list_for_each_entry_safe_reverse(pd_provider, it,
+					 &psci_pd_providers, link) {
 		of_genpd_del_provider(pd_provider->node);
 
 		genpd = of_genpd_remove_last(pd_provider->node);


