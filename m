Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23EBD2BE036;
	Tue,  2 Sep 2025 13:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820265; cv=none; b=KDMP0WqgRk3IQx3N9NDy4axwFZX1xG2NCCysdldqVVJKDOfJOozjV9f9BA7n4CoVfA3Y4WVuUgdSOdlCIY5JMiN5VY9J9IaKwONdTiVYYAo64sGF7sQ9P63C05XhXIj5KMQJMH8I3nCl+7K9xAF+dDzQiPYCm3guUnEvUA+SlCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820265; c=relaxed/simple;
	bh=+hwnmRr0TcHG2A+gehoXFLL4sC8QtZajnsVrvmMQ6zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TgpsVlBjz/caCDkoOAIYS7YfBGT0HbI4HCKMXSakyI2T3q3hKDD9svfNnkFHvLuSt9IZI+JrlQ3IyEKCAWEWz4+EN+whPhnrlL4we56haFrGo//H07gIW+AqzSLelp+cE70dh99NjODLVFLwJgglNE8kHBPGUtKD+OTWAOHpkjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c/OYOaDU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c/OYOaDU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82FB2C4CEED;
	Tue,  2 Sep 2025 13:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820264;
	bh=+hwnmRr0TcHG2A+gehoXFLL4sC8QtZajnsVrvmMQ6zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c/OYOaDU9b5gw3xJEeAzGY4x2Dg7Qc4MppEK+h0RqSp41/pTwcsvZhaJLa7urfrEc
	 7HwDsVxePuDabNywIf+QUZNxTOepbqLa09C6LhPzKJeffGF9uv1FWzT00V6xSpckYa
	 +0ck2wRUn75Nev8bGKaL2/flMqg3vyeFJNuwXdeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takamitsu Iwai <takamitz@amazon.co.jp>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 51/75] net: rose: split remove and free operations in rose_remove_neigh()
Date: Tue,  2 Sep 2025 15:21:03 +0200
Message-ID: <20250902131937.123199740@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takamitsu Iwai <takamitz@amazon.co.jp>

[ Upstream commit dcb34659028f856c423a29ef9b4e2571d203444d ]

The current rose_remove_neigh() performs two distinct operations:
1. Removes rose_neigh from rose_neigh_list
2. Frees the rose_neigh structure

Split these operations into separate functions to improve maintainability
and prepare for upcoming refcount_t conversion. The timer cleanup remains
in rose_remove_neigh() because free operations can be called from timer
itself.

This patch introduce rose_neigh_put() to handle the freeing of rose_neigh
structures and modify rose_remove_neigh() to handle removal only.

Signed-off-by: Takamitsu Iwai <takamitz@amazon.co.jp>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250823085857.47674-2-takamitz@amazon.co.jp
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: d860d1faa6b2 ("net: rose: convert 'use' field to refcount_t")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/rose.h    |  8 ++++++++
 net/rose/rose_route.c | 15 ++++++---------
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/include/net/rose.h b/include/net/rose.h
index 23267b4efcfa3..174b4f605d849 100644
--- a/include/net/rose.h
+++ b/include/net/rose.h
@@ -151,6 +151,14 @@ struct rose_sock {
 
 #define rose_sk(sk) ((struct rose_sock *)(sk))
 
+static inline void rose_neigh_put(struct rose_neigh *rose_neigh)
+{
+	if (rose_neigh->ax25)
+		ax25_cb_put(rose_neigh->ax25);
+	kfree(rose_neigh->digipeat);
+	kfree(rose_neigh);
+}
+
 /* af_rose.c */
 extern ax25_address rose_callsign;
 extern int  sysctl_rose_restart_request_timeout;
diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
index a7054546f52df..b406b1e0fb1e7 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -234,20 +234,12 @@ static void rose_remove_neigh(struct rose_neigh *rose_neigh)
 
 	if ((s = rose_neigh_list) == rose_neigh) {
 		rose_neigh_list = rose_neigh->next;
-		if (rose_neigh->ax25)
-			ax25_cb_put(rose_neigh->ax25);
-		kfree(rose_neigh->digipeat);
-		kfree(rose_neigh);
 		return;
 	}
 
 	while (s != NULL && s->next != NULL) {
 		if (s->next == rose_neigh) {
 			s->next = rose_neigh->next;
-			if (rose_neigh->ax25)
-				ax25_cb_put(rose_neigh->ax25);
-			kfree(rose_neigh->digipeat);
-			kfree(rose_neigh);
 			return;
 		}
 
@@ -331,8 +323,10 @@ static int rose_del_node(struct rose_route_struct *rose_route,
 		if (rose_node->neighbour[i] == rose_neigh) {
 			rose_neigh->count--;
 
-			if (rose_neigh->count == 0 && rose_neigh->use == 0)
+			if (rose_neigh->count == 0 && rose_neigh->use == 0) {
 				rose_remove_neigh(rose_neigh);
+				rose_neigh_put(rose_neigh);
+			}
 
 			rose_node->count--;
 
@@ -513,6 +507,7 @@ void rose_rt_device_down(struct net_device *dev)
 		}
 
 		rose_remove_neigh(s);
+		rose_neigh_put(s);
 	}
 	spin_unlock_bh(&rose_neigh_list_lock);
 	spin_unlock_bh(&rose_node_list_lock);
@@ -569,6 +564,7 @@ static int rose_clear_routes(void)
 		if (s->use == 0 && !s->loopback) {
 			s->count = 0;
 			rose_remove_neigh(s);
+			rose_neigh_put(s);
 		}
 	}
 
@@ -1301,6 +1297,7 @@ void __exit rose_rt_free(void)
 		rose_neigh = rose_neigh->next;
 
 		rose_remove_neigh(s);
+		rose_neigh_put(s);
 	}
 
 	while (rose_node != NULL) {
-- 
2.50.1



