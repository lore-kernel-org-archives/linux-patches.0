Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342BD8F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:55:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A985FC433C8;
	Sun, 16 Jul 2023 20:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540913;
	bh=QfS5XBHp4CM84IYKh5M4g0gtfASuZDQ8E6yO5KvZGMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MyByGc1Ah8GLkoJm56K86r0ULUOOMIJY678tBquJ8hQ6WZzpYvgx1KMMQvWoX4xqR
	 o0TPbL5DbfHePXRv5IjgQZ0I5rWjtLtTYmKXcY1ZupxcUbnzyfVkVXM51c88JygV6e
	 IMj4EZPy4q21kkB5Muu7w8JpX1q0gRYi1AIWwcdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 533/591] wifi: cfg80211: fix regulatory disconnect for non-MLO
Date: Sun, 16 Jul 2023 21:51:12 +0200
Message-ID: <20230716194937.658821497@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

commit b22552fcaf1970360005c805d7fba4046cf2ab4a upstream.

The multi-link loop here broke disconnect when multi-link
operation (MLO) isn't active for a given interface, since
in that case valid_links is 0 (indicating no links, i.e.
no MLO.)

Fix this by taking that into account properly and skipping
the link only if there are valid_links in the first place.

Cc: stable@vger.kernel.org
Fixes: 7b0a0e3c3a88 ("wifi: cfg80211: do some rework towards MLO link APIs")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20230616222844.eb073d650c75.I72739923ef80919889ea9b50de9e4ba4baa836ae@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/reg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2390,7 +2390,7 @@ static bool reg_wdev_chan_valid(struct w
 
 		if (!wdev->valid_links && link > 0)
 			break;
-		if (!(wdev->valid_links & BIT(link)))
+		if (wdev->valid_links && !(wdev->valid_links & BIT(link)))
 			continue;
 		switch (iftype) {
 		case NL80211_IFTYPE_AP:


