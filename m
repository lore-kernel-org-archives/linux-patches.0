Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1714F28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:08:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7288CC433D2;
	Mon, 30 Jan 2023 14:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087694;
	bh=lN6k3dcEO1OI6t8RlQqlMqMPRbyUdFnqj+8KhAzMYSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sGFSc0IIvBbhJkfEuHaL7MQJcPYkAM0fJmLAzT2Gkz5WRVNbEdVMvKukrP66WAP4H
	 FpRxNCiQ6ShknoFaHBFDFLDoh3BYtEY9gDBYwNEqmUdzq7Mu+41pY4bjeWcVCHxRR7
	 a/bokUu1als4XjmkNko0sUPmPO+1PWcNaxFkbnNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 293/313] thermal: intel: int340x: Add locking to int340x_thermal_get_trip_type()
Date: Mon, 30 Jan 2023 14:52:08 +0100
Message-Id: <20230130134350.390599662@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit acd7e9ee57c880b99671dd99680cb707b7b5b0ee ]

In order to prevent int340x_thermal_get_trip_type() from possibly
racing with int340x_thermal_read_trips() invoked by int3403_notify()
add locking to it in analogy with int340x_thermal_get_trip_temp().

Fixes: 6757a7abe47b ("thermal: intel: int340x: Protect trip temperature from concurrent updates")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel/int340x_thermal/int340x_thermal_zone.c       | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
index 852f6c579af5..0a4eaa307156 100644
--- a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
+++ b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
@@ -81,11 +81,13 @@ static int int340x_thermal_get_trip_type(struct thermal_zone_device *zone,
 					 enum thermal_trip_type *type)
 {
 	struct int34x_thermal_zone *d = zone->devdata;
-	int i;
+	int i, ret = 0;
 
 	if (d->override_ops && d->override_ops->get_trip_type)
 		return d->override_ops->get_trip_type(zone, trip, type);
 
+	mutex_lock(&d->trip_mutex);
+
 	if (trip < d->aux_trip_nr)
 		*type = THERMAL_TRIP_PASSIVE;
 	else if (trip == d->crt_trip_id)
@@ -103,10 +105,12 @@ static int int340x_thermal_get_trip_type(struct thermal_zone_device *zone,
 			}
 		}
 		if (i == INT340X_THERMAL_MAX_ACT_TRIP_COUNT)
-			return -EINVAL;
+			ret = -EINVAL;
 	}
 
-	return 0;
+	mutex_unlock(&d->trip_mutex);
+
+	return ret;
 }
 
 static int int340x_thermal_set_trip_temp(struct thermal_zone_device *zone,
-- 
2.39.0



