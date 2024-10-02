Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1457B1D04B4;
	Wed,  2 Oct 2024 14:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880586; cv=none; b=CLb/fFsmdLuhvYRGQOy3Wu9cM0FVHERqcYk5QXPqtjgQq+DGhXq/eBDsdisc8qF0cHWXuIhmhm4qIW5xafIKJId/hfY8VvQlTOZLLXQQItaS9JmH2HkT/O1ssejC4KBlM5LykmQzZ+4Ulw2ExVkJ0MQIZG9li6ALzId5mItfqyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880586; c=relaxed/simple;
	bh=McLbDWffBRT3znpEEtxrGHUKzPhz3XkE/BZWpoVkTco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZZU08QNzWuBZEoHThjdtUFfo7RZl0tsYgpntdbcaRy7rvX7PZNE1tjTf0qI4tpAcl6EtiDkMZ0el6M6owHer0q81sFBiNX1VhoZvBe64wIDgtFq993JP0/kaD3eJ1uopLD3Lcqpx6ECcMLzkgYAsoFo1OGQYr15WFCkchVtBIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=15+26q6L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="15+26q6L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B01C4CEC2;
	Wed,  2 Oct 2024 14:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880586;
	bh=McLbDWffBRT3znpEEtxrGHUKzPhz3XkE/BZWpoVkTco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=15+26q6LDD9x6ODTfGTtjTEAKW+Smln5WhnRiSy/j0thhAtmGC/B11BTMDAb90h7a
	 1x68+p66CI7BzaLj7q4+UWXbKSqLekb6wyvewPAf5v9tV5HGQYBu2mgCbYgPVrbltX
	 9VjUV83KARJ3z7tLP7bTQu+WP7lTLC+JVY7VJ15M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Fine <gil.fine@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Qin Wan <qin.wan@hp.com>,
	Alexandru Gagniuc <alexandru.gagniuc@hp.com>
Subject: [PATCH 6.6 510/538] thunderbolt: Introduce tb_port_path_direction_downstream()
Date: Wed,  2 Oct 2024 15:02:29 +0200
Message-ID: <20241002125812.574521824@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gil Fine <gil.fine@linux.intel.com>

[ Upstream commit 2bfeca73e94567c1a117ca45d2e8a25d63e5bd2c ]

Introduce tb_port_path_direction_downstream() to check if path from
source adapter to destination adapter is directed towards downstream.
Convert existing users to call this helper instead of open-coding.

No functional changes.

Signed-off-by: Gil Fine <gil.fine@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Qin Wan <qin.wan@hp.com>
Signed-off-by: Alexandru Gagniuc <alexandru.gagniuc@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/tb.c     |    6 +++---
 drivers/thunderbolt/tb.h     |   15 +++++++++++++++
 drivers/thunderbolt/tunnel.c |   14 +++++++-------
 3 files changed, 25 insertions(+), 10 deletions(-)

--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -553,7 +553,7 @@ static struct tb_tunnel *tb_find_first_u
 	struct tb_switch *sw;
 
 	/* Pick the router that is deepest in the topology */
-	if (dst_port->sw->config.depth > src_port->sw->config.depth)
+	if (tb_port_path_direction_downstream(src_port, dst_port))
 		sw = dst_port->sw;
 	else
 		sw = src_port->sw;
@@ -1223,7 +1223,7 @@ tb_recalc_estimated_bandwidth_for_group(
 		tb_port_dbg(in, "re-calculated estimated bandwidth %u/%u Mb/s\n",
 			    estimated_up, estimated_down);
 
-		if (in->sw->config.depth < out->sw->config.depth)
+		if (tb_port_path_direction_downstream(in, out))
 			estimated_bw = estimated_down;
 		else
 			estimated_bw = estimated_up;
@@ -2002,7 +2002,7 @@ static void tb_handle_dp_bandwidth_reque
 
 	out = tunnel->dst_port;
 
-	if (in->sw->config.depth < out->sw->config.depth) {
+	if (tb_port_path_direction_downstream(in, out)) {
 		requested_up = -1;
 		requested_down = requested_bw;
 	} else {
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -1044,6 +1044,21 @@ void tb_port_release_out_hopid(struct tb
 struct tb_port *tb_next_port_on_path(struct tb_port *start, struct tb_port *end,
 				     struct tb_port *prev);
 
+/**
+ * tb_port_path_direction_downstream() - Checks if path directed downstream
+ * @src: Source adapter
+ * @dst: Destination adapter
+ *
+ * Returns %true only if the specified path from source adapter (@src)
+ * to destination adapter (@dst) is directed downstream.
+ */
+static inline bool
+tb_port_path_direction_downstream(const struct tb_port *src,
+				  const struct tb_port *dst)
+{
+	return src->sw->config.depth < dst->sw->config.depth;
+}
+
 static inline bool tb_port_use_credit_allocation(const struct tb_port *port)
 {
 	return tb_port_is_null(port) && port->sw->credit_allocation;
--- a/drivers/thunderbolt/tunnel.c
+++ b/drivers/thunderbolt/tunnel.c
@@ -677,7 +677,7 @@ static int tb_dp_xchg_caps(struct tb_tun
 		      "DP OUT maximum supported bandwidth %u Mb/s x%u = %u Mb/s\n",
 		      out_rate, out_lanes, bw);
 
-	if (in->sw->config.depth < out->sw->config.depth)
+	if (tb_port_path_direction_downstream(in, out))
 		max_bw = tunnel->max_down;
 	else
 		max_bw = tunnel->max_up;
@@ -802,7 +802,7 @@ static int tb_dp_bandwidth_alloc_mode_en
 	 * max_up/down fields. For discovery we just read what the
 	 * estimation was set to.
 	 */
-	if (in->sw->config.depth < out->sw->config.depth)
+	if (tb_port_path_direction_downstream(in, out))
 		estimated_bw = tunnel->max_down;
 	else
 		estimated_bw = tunnel->max_up;
@@ -972,7 +972,7 @@ static int tb_dp_bandwidth_mode_consumed
 	if (allocated_bw == max_bw)
 		allocated_bw = ret;
 
-	if (in->sw->config.depth < out->sw->config.depth) {
+	if (tb_port_path_direction_downstream(in, out)) {
 		*consumed_up = 0;
 		*consumed_down = allocated_bw;
 	} else {
@@ -1007,7 +1007,7 @@ static int tb_dp_allocated_bandwidth(str
 		if (allocated_bw == max_bw)
 			allocated_bw = ret;
 
-		if (in->sw->config.depth < out->sw->config.depth) {
+		if (tb_port_path_direction_downstream(in, out)) {
 			*allocated_up = 0;
 			*allocated_down = allocated_bw;
 		} else {
@@ -1035,7 +1035,7 @@ static int tb_dp_alloc_bandwidth(struct
 	if (ret < 0)
 		return ret;
 
-	if (in->sw->config.depth < out->sw->config.depth) {
+	if (tb_port_path_direction_downstream(in, out)) {
 		tmp = min(*alloc_down, max_bw);
 		ret = usb4_dp_port_allocate_bandwidth(in, tmp);
 		if (ret)
@@ -1133,7 +1133,7 @@ static int tb_dp_maximum_bandwidth(struc
 	if (ret < 0)
 		return ret;
 
-	if (in->sw->config.depth < tunnel->dst_port->sw->config.depth) {
+	if (tb_port_path_direction_downstream(in, tunnel->dst_port)) {
 		*max_up = 0;
 		*max_down = ret;
 	} else {
@@ -1191,7 +1191,7 @@ static int tb_dp_consumed_bandwidth(stru
 		return 0;
 	}
 
-	if (in->sw->config.depth < tunnel->dst_port->sw->config.depth) {
+	if (tb_port_path_direction_downstream(in, tunnel->dst_port)) {
 		*consumed_up = 0;
 		*consumed_down = tb_dp_bandwidth(rate, lanes);
 	} else {


