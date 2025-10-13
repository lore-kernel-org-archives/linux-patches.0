Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E323090DE;
	Mon, 13 Oct 2025 15:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368632; cv=none; b=HPQ22lNT8yh/ixpcddBixnW3/M42+RN14TCi4hm6LT2q3lri6zYU1gwJv7TmgIiLrT5H1RM1UDUaNeWbp/SDYO0jpEnDUHh5mWL1FT7hiPNbB8DrgPxRg/QF+EcyqYgXDhCufx6hVy+CFYAgVA7HCfkbJqk0JsNt4htXobLWJxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368632; c=relaxed/simple;
	bh=i+fqnV+t/vhL0JjPY2CB1jRLrXGOUkpOq91vqy2/xHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=epLvAnSSoP/koxJLjatYMqCw35MbeGxA3bav35kmzXnVRPQlmQx+32EA/6VOWdDeF5dToYtiTGbLEWioDAxrGl6OLpRLiI2rHBKUAkwO/D27hcjfVMmE1hkAL4eBA14d4Es4aPUbB31SZtrgGASKpUW8L3Avxlz2mOpBXe7ie5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JG3r97A7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JG3r97A7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A46C4CEE7;
	Mon, 13 Oct 2025 15:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368632;
	bh=i+fqnV+t/vhL0JjPY2CB1jRLrXGOUkpOq91vqy2/xHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JG3r97A7KhIWjkUWM92xJkrqeTLictcUQZ+rfguUbRzdzdBqz2LNMxnyM/MqNkvXq
	 vmNrr7C/TBWItvbYeUeEvloCDvb1J3kDM367u8laDQM11LniZ7fhRGOhjbWzc5t1BM
	 9G8c9DX4Ckov9t6EvrDVXmjHaMWbM0TjoLhYIUZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 229/262] ASoC: SOF: ipc3-topology: Fix multi-core and static pipelines tear down
Date: Mon, 13 Oct 2025 16:46:11 +0200
Message-ID: <20251013144334.489146737@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

commit 59abe7bc7e7c70e9066b3e46874d1b7e6a13de14 upstream.

In the case of static pipelines, freeing the widgets in the pipelines
that were not suspended after freeing the scheduler widgets results in
errors because the secondary cores are powered off when the scheduler
widgets are freed. Fix this by tearing down the leftover pipelines before
powering off the secondary cores.

Cc: stable@vger.kernel.org
Fixes: d7332c4a4f1a ("ASoC: SOF: ipc3-topology: Fix pipeline tear down logic")
Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20251002073125.32471-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc3-topology.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/sound/soc/sof/ipc3-topology.c
+++ b/sound/soc/sof/ipc3-topology.c
@@ -2485,11 +2485,6 @@ static int sof_ipc3_tear_down_all_pipeli
 	if (ret < 0)
 		return ret;
 
-	/* free all the scheduler widgets now */
-	ret = sof_ipc3_free_widgets_in_list(sdev, true, &dyn_widgets, verify);
-	if (ret < 0)
-		return ret;
-
 	/*
 	 * Tear down all pipelines associated with PCMs that did not get suspended
 	 * and unset the prepare flag so that they can be set up again during resume.
@@ -2505,6 +2500,11 @@ static int sof_ipc3_tear_down_all_pipeli
 		}
 	}
 
+	/* free all the scheduler widgets now. This will also power down the secondary cores */
+	ret = sof_ipc3_free_widgets_in_list(sdev, true, &dyn_widgets, verify);
+	if (ret < 0)
+		return ret;
+
 	list_for_each_entry(sroute, &sdev->route_list, list)
 		sroute->setup = false;
 


