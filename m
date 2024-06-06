Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5B01AC251;
	Thu,  6 Jun 2024 14:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683309; cv=none; b=RHpc/osrFLr0G3miBtCj87WCqFBXVbl7n7eFdtjeEZ4Kl4zWdbPZ1KOGZPHrDiFzg5JpoSmL9kmokBndWWFOrTvbLzoUJhC2b1tqAZAZOrnUGKyzBnGV6LnamhuK9A4adgt9iujW6uGjQALqWvcUXK6HsKtyvl7HiWVaL5xhQ78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683309; c=relaxed/simple;
	bh=6vX3b8zHVqtuAoQlCOorNJHSCARp9viSdfI9herC94s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UTcuIDvx9Qzn7DfvJUAlZUYgFp5Q8A0rcDoimqGd6dI94vS/KnFG7jAddU+sxWpSHUfq6nWpsEDAPccMiJcBGS37YQ0BX8J0E+nh+UtZl7e7LwLA5Pha99rR5yPbO/zBpM5NFD9QA7qevf4VN4GrvE1gO8siQ0FZageZMGIhAcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vzov2r1H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vzov2r1H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A06DC2BD10;
	Thu,  6 Jun 2024 14:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683309;
	bh=6vX3b8zHVqtuAoQlCOorNJHSCARp9viSdfI9herC94s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vzov2r1H2HygFow1IZZApH6ZPnWTDZXB4XMlOgs7U+8ry7JUG5eSQEmsPtnjJfQ6T
	 cD0M47jzRZTKpgsh3N+SPH4VvXce4jJ6KQ+pBRI2dK35T50rcuRY8I6SNC79brEkhA
	 nM6b0M0gl0J/yF1lgXKrWCzQK1++dW5WR/uiJD1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jagan Teki <jagan@amarulasolutions.com>,
	Michael Trimarchi <michael@amarulasolutions.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 189/473] drm/bridge: Fix improper bridge init order with pre_enable_prev_first
Date: Thu,  6 Jun 2024 16:01:58 +0200
Message-ID: <20240606131706.187407349@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Jagan Teki <jagan@amarulasolutions.com>

[ Upstream commit e18aeeda0b6905c333df5a0566b99f5c84426098 ]

For a given bridge pipeline if any bridge sets pre_enable_prev_first
flag then the pre_enable for the previous bridge will be called before
pre_enable of this bridge and opposite is done for post_disable.

These are the potential bridge flags to alter bridge init order in order
to satisfy the MIPI DSI host and downstream panel or bridge to function.
However the existing pre_enable_prev_first logic with associated bridge
ordering has broken for both pre_enable and post_disable calls.

[pre_enable]

The altered bridge ordering has failed if two consecutive bridges on a
given pipeline enables the pre_enable_prev_first flag.

Example:
- Panel
- Bridge 1
- Bridge 2 pre_enable_prev_first
- Bridge 3
- Bridge 4 pre_enable_prev_first
- Bridge 5 pre_enable_prev_first
- Bridge 6
- Encoder

In this example, Bridge 4 and Bridge 5 have pre_enable_prev_first.

The logic looks for a bridge which enabled pre_enable_prev_first flag
on each iteration and assigned the previou bridge to limit pointer
if the bridge doesn't enable pre_enable_prev_first flags.

If control found Bridge 2 is pre_enable_prev_first then the iteration
looks for Bridge 3 and found it is not pre_enable_prev_first and assigns
it's previous Bridge 4 to limit pointer and calls pre_enable of Bridge 3
and Bridge 2 and assign iter pointer with limit which is Bridge 4.

Here is the actual problem, for the next iteration control look for
Bridge 5 instead of Bridge 4 has iter pointer in previous iteration
moved to Bridge 4 so this iteration skips the Bridge 4. The iteration
found Bridge 6 doesn't pre_enable_prev_first flags so the limit assigned
to Encoder. From next iteration Encoder skips as it is the last bridge
for reverse order pipeline.

So, the resulting pre_enable bridge order would be,
- Panel, Bridge 1, Bridge 3, Bridge 2, Bridge 6, Bridge 5.

This patch fixes this by assigning limit to next pointer instead of
previous bridge since the iteration always looks for bridge that does
NOT request prev so assigning next makes sure the last bridge on a
given iteration what exactly the limit bridge is.

So, the resulting pre_enable bridge order with fix would be,
- Panel, Bridge 1, Bridge 3, Bridge 2, Bridge 6, Bridge 5, Bridge 4,
  Encoder.

[post_disable]

The altered bridge ordering has failed if two consecutive bridges on a
given pipeline enables the pre_enable_prev_first flag.

Example:
- Panel
- Bridge 1
- Bridge 2 pre_enable_prev_first
- Bridge 3
- Bridge 4 pre_enable_prev_first
- Bridge 5 pre_enable_prev_first
- Bridge 6
- Encoder

In this example Bridge 5 and Bridge 4 have pre_enable_prev_first.

The logic looks for a bridge which enabled pre_enable_prev_first flags
on each iteration and assigned the previou bridge to next and next to
limit pointer if the bridge does enable pre_enable_prev_first flag.

If control starts from Bridge 6 then it found next Bridge 5 is
pre_enable_prev_first and immediately the next assigned to previous
Bridge 6 and limit assignments to next Bridge 6 and call post_enable
of Bridge 6 even though the next consecutive Bridge 5 is enabled with
pre_enable_prev_first. This clearly misses the logic to find the state
of next conducive bridge as everytime the next and limit assigns
previous bridge if given bridge enabled pre_enable_prev_first.

So, the resulting post_disable bridge order would be,
- Encoder, Bridge 6, Bridge 5, Bridge 4, Bridge 3, Bridge 2, Bridge 1,
  Panel.

This patch fixes this by assigning next with previou bridge only if the
bridge doesn't enable pre_enable_prev_first flag and the next further
assign it to limit. This way we can find the bridge that NOT requested
prev to disable last.

So, the resulting pre_enable bridge order with fix would be,
- Encoder, Bridge 4, Bridge 5, Bridge 6, Bridge 2, Bridge 3, Bridge 1,
  Panel.

Validated the bridge init ordering by incorporating dummy bridges in
the sun6i-mipi-dsi pipeline

Fixes: 4fb912e5e190 ("drm/bridge: Introduce pre_enable_prev_first to alter bridge init order")
Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
Tested-by: Michael Trimarchi <michael@amarulasolutions.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230328170752.1102347-1-jagan@amarulasolutions.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_bridge.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_bridge.c b/drivers/gpu/drm/drm_bridge.c
index 7044e339a82cd..f802548798044 100644
--- a/drivers/gpu/drm/drm_bridge.c
+++ b/drivers/gpu/drm/drm_bridge.c
@@ -755,11 +755,17 @@ void drm_atomic_bridge_chain_post_disable(struct drm_bridge *bridge,
 				 */
 				list_for_each_entry_from(next, &encoder->bridge_chain,
 							 chain_node) {
-					if (next->pre_enable_prev_first) {
+					if (!next->pre_enable_prev_first) {
 						next = list_prev_entry(next, chain_node);
 						limit = next;
 						break;
 					}
+
+					if (list_is_last(&next->chain_node,
+							 &encoder->bridge_chain)) {
+						limit = next;
+						break;
+					}
 				}
 
 				/* Call these bridges in reverse order */
@@ -842,7 +848,7 @@ void drm_atomic_bridge_chain_pre_enable(struct drm_bridge *bridge,
 					/* Found first bridge that does NOT
 					 * request prev to be enabled first
 					 */
-					limit = list_prev_entry(next, chain_node);
+					limit = next;
 					break;
 				}
 			}
-- 
2.43.0



