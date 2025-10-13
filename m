Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2A930BF7D;
	Mon, 13 Oct 2025 15:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367995; cv=none; b=HG0wH+L1sZG0kN6hO6c8Der+8jgsfNdeBblae69Fy+Kizt7gxzLqYHfuWqddPck7nf0W3cZy4l4PXz/ARfIfGJ/W2/WX7EoUSCAV6lm46RPFCR5bO2dn8JFGsIFpsZsCFxyc8id0uJk232fsilyDPW+B1kw2n09P2v3Nk6chtos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367995; c=relaxed/simple;
	bh=RuP//OzXCBgB/hVa5fVydrygztCQA9vQQjTG5D0FI2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nMIj0RS50znHxJuqmcz08F/D92pYW5du3h3zU+ovRBxirwXZeUBTX6dAhfBxX8Nf1HeokXRBtWEtKFqcsGhkzivrdTPgvDiPL40em1ecuL8+CG3PRYvWeeYQi6Pusl1huuybXSndloPutMVRC/qrtEPOeW5ftrWz07PDCGzM824=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vG8wkjzt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vG8wkjzt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB8EC4CEE7;
	Mon, 13 Oct 2025 15:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367995;
	bh=RuP//OzXCBgB/hVa5fVydrygztCQA9vQQjTG5D0FI2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vG8wkjztY8W9YbOAmq6LymHwz2Q1m3rAG2UVK1l549c7uxFBG47wY8fzU3ys6TdQd
	 evUBRRnylxovQqn5UYUdrk4N5EUGGQbu1aF6ptidOJjLvyunL6S5rzvpoqnJQLeZef
	 xda3vWr0P1MStNnWmiI6eru3NiTADGdOXiOxwjMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 172/196] ASoC: SOF: ipc3-topology: Fix multi-core and static pipelines tear down
Date: Mon, 13 Oct 2025 16:46:03 +0200
Message-ID: <20251013144321.531522015@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2394,11 +2394,6 @@ static int sof_ipc3_tear_down_all_pipeli
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
@@ -2414,6 +2409,11 @@ static int sof_ipc3_tear_down_all_pipeli
 		}
 	}
 
+	/* free all the scheduler widgets now. This will also power down the secondary cores */
+	ret = sof_ipc3_free_widgets_in_list(sdev, true, &dyn_widgets, verify);
+	if (ret < 0)
+		return ret;
+
 	list_for_each_entry(sroute, &sdev->route_list, list)
 		sroute->setup = false;
 


