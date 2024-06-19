Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279E0143757;
	Wed, 19 Jun 2024 13:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803258; cv=none; b=q72OBPSq08gGbf+/g88u2JSI/htWcp5b4rbbtBmDQJCazxaFr/OU2SNwSOcPyznsJYCDZOtIYcHi3V2Vamyq0IqFzGAH0nfIsqz8aX0aLn0OFgx+Y2JUEIIf/9u+vjQpsnmgMMLCISrS2HQL2Orn4XsSFOV9NvLbTJVKjlQ09sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803258; c=relaxed/simple;
	bh=hisnOorvDbekk7VFC99rIDyxLMCR/nEi6sgwEDbb0wI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vFmmvclb5tu3oLECzydpV50IX81kfjkOfJfC7qf3bxhwI1F+0nd1slrzZAMiP+gaFvY2wtzpZhvoyetX5Muo+d4vOUzCMiyRMS6smuoCzFOSQsrGtGSoIctFb0hE64g9YnmDlt2wfiCREc3J37AIkT1J+aQqQmd9uA768k8InFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IGn8uAPr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IGn8uAPr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D76C2BBFC;
	Wed, 19 Jun 2024 13:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803258;
	bh=hisnOorvDbekk7VFC99rIDyxLMCR/nEi6sgwEDbb0wI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IGn8uAPrjRcdyXrZh6TNWBdFwYlbUVbIB3l7GHidePd/ckG100auhII7vKh4IgMk/
	 9qBox/qYfr8pjmveRgrYjRnILrXQMe1huxJrfXtM5ssDvwRoKpTtJejSDAueblwpch
	 Nwx2lxO/ltx4fjDBTcjAG+EJ69VMuRouuMt/uHnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tibor Billes <tbilles@gmx.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.9 205/281] thermal: ACPI: Invalidate trip points with temperature of 0 or below
Date: Wed, 19 Jun 2024 14:56:04 +0200
Message-ID: <20240619125617.838461860@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 7f18bd49cb6b6a3ab6d860fefccdc94f2a247db0 upstream.

It is reported that commit 950210887670 ("thermal: core: Drop
trips_disabled bitmask") causes the maximum frequency of CPUs to drop
further down with every system sleep-wake cycle on Intel Core i7-4710HQ.

This turns out to be due to a trip point whose temperature is equal to 0
degrees Celsius which is acted on every time the system wakes from sleep.

Before commit 950210887670 this trip point would be disabled wia the
trips_disabled bitmask, but now it is treated as a valid one.

Since ACPI thermal control is generally about protection against
overheating, trip points with temperature of 0 centigrade or below are
not particularly useful there, so initialize them all as invalid which
fixes the problem at hand.

Fixes: 950210887670 ("thermal: core: Drop trips_disabled bitmask")
Closes: https://lore.kernel.org/linux-pm/3f71747b-f852-4ee0-b384-cf46b2aefa3f@gmx.com
Reported-by: Tibor Billes <tbilles@gmx.com>
Tested-by: Tibor Billes <tbilles@gmx.com>
Cc: 6.7+ <stable@vger.kernel.org> # 6.7+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/thermal.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -168,11 +168,17 @@ static int acpi_thermal_get_polling_freq
 
 static int acpi_thermal_temp(struct acpi_thermal *tz, int temp_deci_k)
 {
+	int temp;
+
 	if (temp_deci_k == THERMAL_TEMP_INVALID)
 		return THERMAL_TEMP_INVALID;
 
-	return deci_kelvin_to_millicelsius_with_offset(temp_deci_k,
+	temp = deci_kelvin_to_millicelsius_with_offset(temp_deci_k,
 						       tz->kelvin_offset);
+	if (temp <= 0)
+		return THERMAL_TEMP_INVALID;
+
+	return temp;
 }
 
 static bool acpi_thermal_trip_valid(struct acpi_thermal_trip *acpi_trip)


