Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C29C1C4EEC;
	Tue, 27 Aug 2024 15:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771657; cv=none; b=SHIhiIKPzKO2ZYVbVKX1Ou6E+rfG23mIwQNGjEjSt7Q9pN9QzHGfQvqBLj9zf/TgAZeUfwOCxYNpy3bIuE6C+CfCP5OYw2Ols5eC/rm6IKA4h80HO/yrmbkzLYcrxkIergwBo+2kINQpWPHUW/kbVV8u1cw6GTira/7vS0u2uLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771657; c=relaxed/simple;
	bh=v6esvDpBgAHQQvWnGGIXp1aXUDlDY+j2wSt+L8VdDkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bFL5YSut74s7i6HaTGuUic0mAOkgofJlanmDhzHKRGutBAhu1Ym2QP5CkfRkzB3ErO+bgU8yFNgvXBONw1mY6eKvPc6/YuxolGrtoLTK/LrIKmEsQWqCm3y/Zj7nYtap0QdP8DnCP0GocnSoAV53KNrL0DiVHwBWWFlTEM+c830=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KAq67la2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KAq67la2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391F4C6106E;
	Tue, 27 Aug 2024 15:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771656;
	bh=v6esvDpBgAHQQvWnGGIXp1aXUDlDY+j2wSt+L8VdDkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KAq67la25gQdQ4P8Fxlma5PHwPQcalE0Fx8KyunabIJne3XbuyQmhPTPPbnF+Z6uo
	 VVBxjt9XmkeYwp+Q8Nq/QRZ73xdRB9othsq/faRxylA3AAtd/WJzCCk17lf+9ijprT
	 GtH1AbCtos6yr4o/H+AMIaPTLR6sH9oXYolZFNog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.10 254/273] thermal: of: Fix OF node leak in of_thermal_zone_find() error paths
Date: Tue, 27 Aug 2024 16:39:38 +0200
Message-ID: <20240827143843.067344664@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit c0a1ef9c5be72ff28a5413deb1b3e1a066593c13 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/thermal_of.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/thermal/thermal_of.c
+++ b/drivers/thermal/thermal_of.c
@@ -184,14 +184,14 @@ static struct device_node *of_thermal_zo
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
@@ -200,18 +200,19 @@ static struct device_node *of_thermal_zo
 
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


