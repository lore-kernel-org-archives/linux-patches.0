Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4F937F730;
	Thu, 20 Aug 2026 15:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238828; cv=none; b=LXhczrAPzl/mDbl/DA+n7yvsQgTq0SFn3QBUSJuR/LdieUVGtTqO1hyxdSER0Y8VVl36gk2JEIoxrkSURDn/8Qv58C7THETib64+iOdy83b4veRgKYR9xCjC4B068RlJn2rwWf5vcnI2A8gH2L902H6FT6EvK3PKA/2J5jpvAj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238828; c=relaxed/simple;
	bh=Vjma/OEIgvNYbvGK+kadw49WDWXF476c+W8MKf0uW6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kEj9LePDZ0mktqw6guo0GKoMlkULPypdmO0Qc+P48OQIPyOzaPIW8aN79Xq2XwZcMwHzs9Peo9c1vQmXEK5TZHGFhZfcaIrV2Bglkmk4o6vsTBxP9JSjF7WfPkCNidhhH4ivw993PInxKV67BL0ceR/Bihe+csENtsJyEXqqLVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q9MczAVs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q9MczAVs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9571F00A3A;
	Thu, 20 Aug 2026 15:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238827;
	bh=8CW7kzVlSnjMpV/+F35fs8Df5ldAK1QBt1RRmG9NZlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q9MczAVsjpHgxNavl8xYTqTnPMcJ2oNnWLaOnQiLI3X5xD3GtvLYbBBijaCdNtB8D
	 awrTMv0cRVs9nYjB9Ot7rL+kZoFoHnYNvjIjhzAPmm7TdCtdg8oxV0JOJ54KYc5ML/
	 kBAc7owhYsIo1e2CidHGvZLlVljGok+af5aXjlW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Praveen Talari <praveen.talari@oss.qualcomm.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 055/217] pmdomain: arm: Fix -EINVAL from scmi_pd_set_perf_state() on state 0
Date: Thu, 20 Aug 2026 16:53:43 +0200
Message-ID: <20260820145239.273953496@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Praveen Talari <praveen.talari@oss.qualcomm.com>

commit 3314c90a2eda3df7da4ab6f4388e667b2758de7f upstream.

Currently, scmi_pd_set_perf_state() treats a performance state of 0 as
invalid and returns -EINVAL. As a result, devices attached to SCMI
performance domains can report failures when relinquishing their
performance vote.

The OPP framework use performance state 0 to indicate that no performance
vote is required. For example, dev_pm_opp_set_rate(dev, 0) is commonly
used (by firmware or linux)  when a device is runtime suspended.

A zero performance state does not require any SCMI performance request
to be sent. Treat it as a no-op and return success instead of reporting
an error.

Signed-off-by: Praveen Talari <praveen.talari@oss.qualcomm.com>
Fixes: 2af23ceb8624 ("pmdomain: arm: Add the SCMI performance domain")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/arm/scmi_perf_domain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pmdomain/arm/scmi_perf_domain.c
+++ b/drivers/pmdomain/arm/scmi_perf_domain.c
@@ -33,7 +33,7 @@ scmi_pd_set_perf_state(struct generic_pm
 		return 0;
 
 	if (!state)
-		return -EINVAL;
+		return 0;
 
 	ret = pd->perf_ops->level_set(pd->ph, pd->domain_id, state, false);
 	if (ret)


