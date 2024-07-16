Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF3317A93F;
	Tue, 16 Jul 2024 15:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145151; cv=none; b=Org/AGoPUsh19q1zKLjfAyeGgBLI0pYMF63ehpubnQ7jwlIFAlfKodpVQhyH180cBg8FfEVyacAQFNGSLI8is624txNxSmpsP8i3mfqyJj1Bw0FpRKJUzFfrWOiX45JwPCQ6x+t8HLImr81fCmLEwedImzVQFCdPAcqBzCWsC08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145151; c=relaxed/simple;
	bh=QTe64/+/HuPCuDrBD8TWI1zbnoc/jf6tYcdWkgZ+ayw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B+dAhy+uDB6yeozlFhKLUGgAbHgFYfUb1GbxygVVswyOEy+zG2cHL7oE3cLpOBSd+s4KeE+zRAZTn78TWVlFSvJMdYsMvETpZopk2XVIO6taS9A3EtWW3I3NA58+BehtMhHJ5t5xEXesE6xvSjXEm0KiplgNOmMZfl6XqHGHu9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kuBuu+zU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kuBuu+zU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED36C116B1;
	Tue, 16 Jul 2024 15:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145150;
	bh=QTe64/+/HuPCuDrBD8TWI1zbnoc/jf6tYcdWkgZ+ayw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kuBuu+zUibDAKv2ibCbxR7Ha5RiiOOZzQau+VPHrSSnEcjMfLDVJehLUrqeZL3nZ6
	 tNJYlqxENwapkIkIEvWfLfql7zPVWQk2UxC0i4rGkXaONIptKCu7IV6nGSgNC2MMYD
	 pTNUx0h/NDv2vYunIS969vBImv6SS1T0mgLI2z9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <andersson@kernel.org>,
	Taniya Das <quic_tdas@quicinc.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.9 115/143] pmdomain: qcom: rpmhpd: Skip retention level for Power Domains
Date: Tue, 16 Jul 2024 17:31:51 +0200
Message-ID: <20240716152800.402050494@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

From: Taniya Das <quic_tdas@quicinc.com>

commit ddab91f4b2de5c5b46e312a90107d9353087d8ea upstream.

In the cases where the power domain connected to logics is allowed to
transition from a level(L)-->power collapse(0)-->retention(1) or
vice versa retention(1)-->power collapse(0)-->level(L)  will cause the
logic to lose the configurations. The ARC does not support retention
to collapse transition on MxC rails.

The targets from SM8450 onwards the PLL logics of clock controllers are
connected to MxC rails and the recommended configurations are carried
out during the clock controller probes. The MxC transition as mentioned
above should be skipped to ensure the PLL settings are intact across
clock controller power on & off.

On older targets that do not split MX into MxA and MxC does not collapse
the logic and it is parked always at RETENTION, thus this issue is never
observed on those targets.

Cc: stable@vger.kernel.org # v5.17
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
Link: https://lore.kernel.org/r/20240625-avoid_mxc_retention-v2-1-af9c2f549a5f@quicinc.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/qcom/rpmhpd.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/pmdomain/qcom/rpmhpd.c
+++ b/drivers/pmdomain/qcom/rpmhpd.c
@@ -40,6 +40,7 @@
  * @addr:		Resource address as looped up using resource name from
  *			cmd-db
  * @state_synced:	Indicator that sync_state has been invoked for the rpmhpd resource
+ * @skip_retention_level: Indicate that retention level should not be used for the power domain
  */
 struct rpmhpd {
 	struct device	*dev;
@@ -56,6 +57,7 @@ struct rpmhpd {
 	const char	*res_name;
 	u32		addr;
 	bool		state_synced;
+	bool            skip_retention_level;
 };
 
 struct rpmhpd_desc {
@@ -173,6 +175,7 @@ static struct rpmhpd mxc = {
 	.pd = { .name = "mxc", },
 	.peer = &mxc_ao,
 	.res_name = "mxc.lvl",
+	.skip_retention_level = true,
 };
 
 static struct rpmhpd mxc_ao = {
@@ -180,6 +183,7 @@ static struct rpmhpd mxc_ao = {
 	.active_only = true,
 	.peer = &mxc,
 	.res_name = "mxc.lvl",
+	.skip_retention_level = true,
 };
 
 static struct rpmhpd nsp = {
@@ -819,6 +823,9 @@ static int rpmhpd_update_level_mapping(s
 		return -EINVAL;
 
 	for (i = 0; i < rpmhpd->level_count; i++) {
+		if (rpmhpd->skip_retention_level && buf[i] == RPMH_REGULATOR_LEVEL_RETENTION)
+			continue;
+
 		rpmhpd->level[i] = buf[i];
 
 		/* Remember the first corner with non-zero level */


