Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047FB186E3B;
	Sun,  1 Sep 2024 16:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209195; cv=none; b=Fyq9nL9b6oA+FVQMaDWiW5hqWhcXjV5OGEX2Eg0uoA05FngZ4/9xJeTYwx3XICPRO/sqgrX4LONHTxEYoOaMDrxD4qsVsW9PJmpCINIurWHVXZvmERu9aS2QIDE6rSwrptCAlHu+ua1E2nQSraHZDUBBZwTR/FXQIgqsP5lXHpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209195; c=relaxed/simple;
	bh=Fd8T90vfOzWMoUedCqP3SI8t3erLJ4A+A9khb46PMys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AmVer8QANjCM6mp4z05CF7lXN55kmrKfMN0QjwgwutMQ2RJUkeQJ3fRabDdJsnK9ounQfASl8h8DbyHCDlq983hROw5pLiDg570M/q6fc2+dPmdvwZZZE49VMBR03FtUWzPpXrVJCxkEQznkB0b+jIJ9wmRWYnoc7atNOhpXITA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xUrGDFdq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xUrGDFdq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9ACC4CEC4;
	Sun,  1 Sep 2024 16:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209193;
	bh=Fd8T90vfOzWMoUedCqP3SI8t3erLJ4A+A9khb46PMys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xUrGDFdq89MQhXBQRDkYManHwI3wZnH2di56/t5IuCUXu6HqzDf8OkbjkoWSGr4rQ
	 ry47RghvvitDnjcl01dceU06oai4No2lrLMa3kN/9CIJ543qDYS61d0w7k6+laszRT
	 vS+qKkOF0t4W+vbN3sUKYGRC2QCgbDEUHgNLnsX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 30/71] thermal: of: Fix OF node leak in of_thermal_zone_find() error paths
Date: Sun,  1 Sep 2024 18:17:35 +0200
Message-ID: <20240901160803.026968164@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit c0a1ef9c5be72ff28a5413deb1b3e1a066593c13 ]

Terminating for_each_available_child_of_node() loop requires dropping OF
node reference, so bailing out on errors misses this.  Solve the OF node
reference leak with scoped for_each_available_child_of_node_scoped().

Fixes: 3fd6d6e2b4e8 ("thermal/of: Rework the thermal device tree initialization")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://patch.msgid.link/20240814195823.437597-3-krzysztof.kozlowski@linaro.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_of.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
index 62099ffcd9721..323c8cd171485 100644
--- a/drivers/thermal/thermal_of.c
+++ b/drivers/thermal/thermal_of.c
@@ -294,14 +294,14 @@ static struct device_node *of_thermal_zone_find(struct device_node *sensor, int
 	 * Search for each thermal zone, a defined sensor
 	 * corresponding to the one passed as parameter
 	 */
-	for_each_available_child_of_node(np, tz) {
+	for_each_available_child_of_node_scoped(np, child) {
 
 		int count, i;
 
-		count = of_count_phandle_with_args(tz, "thermal-sensors",
+		count = of_count_phandle_with_args(child, "thermal-sensors",
 						   "#thermal-sensor-cells");
 		if (count <= 0) {
-			pr_err("%pOFn: missing thermal sensor\n", tz);
+			pr_err("%pOFn: missing thermal sensor\n", child);
 			tz = ERR_PTR(-EINVAL);
 			goto out;
 		}
@@ -310,18 +310,19 @@ static struct device_node *of_thermal_zone_find(struct device_node *sensor, int
 
 			int ret;
 
-			ret = of_parse_phandle_with_args(tz, "thermal-sensors",
+			ret = of_parse_phandle_with_args(child, "thermal-sensors",
 							 "#thermal-sensor-cells",
 							 i, &sensor_specs);
 			if (ret < 0) {
-				pr_err("%pOFn: Failed to read thermal-sensors cells: %d\n", tz, ret);
+				pr_err("%pOFn: Failed to read thermal-sensors cells: %d\n", child, ret);
 				tz = ERR_PTR(ret);
 				goto out;
 			}
 
 			if ((sensor == sensor_specs.np) && id == (sensor_specs.args_count ?
 								  sensor_specs.args[0] : 0)) {
-				pr_debug("sensor %pOFn id=%d belongs to %pOFn\n", sensor, id, tz);
+				pr_debug("sensor %pOFn id=%d belongs to %pOFn\n", sensor, id, child);
+				tz = no_free_ptr(child);
 				goto out;
 			}
 		}
-- 
2.43.0



