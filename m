Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23C122AE68;
	Tue, 29 Apr 2025 17:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949211; cv=none; b=vES/ktPHm2PRCsfFP0DjspXeZylNwjr8PvQ/smT5h7k7GX//jN6F8osOde+myd9zC+7jeMQgeG5rjUigwfmjqRQUgDPef+gQb0EV1Ny8Dw8s0VNhhvtvtMbq1KJ8q0mdvdOfIH8pr1tpG6gfAF6bKjqfoyB8OkxfoRJdN7qySQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949211; c=relaxed/simple;
	bh=870Zqz8rtEdCoSW8xRVdOs93I4hs9zsgUjLSEqSqatI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJyQSOjp6+D4ZlnAs0Q4XQzZi3gZCEdRkEo6fb9LXBFQXfkgYZBopSxVswXsHtCDp3mrfnr/lYi8FVg4WPEcZ3xM22+KcQqOHLxWgUmz4pmDMih+RNsksfRM9B081v8dKuZHblvyDkkuqdQyHsPWGmjraFJsUR+8m8xv/yxLjBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Zgx+GKx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Zgx+GKx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62889C4CEE3;
	Tue, 29 Apr 2025 17:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949211;
	bh=870Zqz8rtEdCoSW8xRVdOs93I4hs9zsgUjLSEqSqatI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Zgx+GKx4P69BURAyLNjZmbx5vnak5TvbtgvcyN5orlYhJVzth0/aFPEfbHs0FHHY
	 5RVjcffXCHIu39ib8pqxZ+2rItLtCittXHrEoa/kf1ydDIn2EPSwBwEIAu/UQhnZuO
	 S2L0aQBRYOnyWk0nYsRYPIa0OWopUfq+bCbPs3lQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Wilson <chris.p.wilson@intel.com>,
	Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Zhi Yang <Zhi.Yang@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.15 246/373] drm/i915/gt: Cleanup partial engine discovery failures
Date: Tue, 29 Apr 2025 18:42:03 +0200
Message-ID: <20250429161133.244014371@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris.p.wilson@intel.com>

commit 78a033433a5ae4fee85511ee075bc9a48312c79e upstream.

If we abort driver initialisation in the middle of gt/engine discovery,
some engines will be fully setup and some not. Those incompletely setup
engines only have 'engine->release == NULL' and so will leak any of the
common objects allocated.

v2:
 - Drop the destroy_pinned_context() helper for now.  It's not really
   worth it with just a single callsite at the moment.  (Janusz)

Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
Cc: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220915232654.3283095-2-matthew.d.roper@intel.com
Signed-off-by: Zhi Yang <Zhi.Yang@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_engine_cs.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
@@ -983,8 +983,13 @@ int intel_engines_init(struct intel_gt *
 			return err;
 
 		err = setup(engine);
-		if (err)
+		if (err) {
+			intel_engine_cleanup_common(engine);
 			return err;
+		}
+
+		/* The backend should now be responsible for cleanup */
+		GEM_BUG_ON(engine->release == NULL);
 
 		err = engine_init_common(engine);
 		if (err)


