Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771FC1A58C
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 09:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g9TTYFly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943DEC433C7;
	Mon, 16 Oct 2023 09:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697447161;
	bh=5z/n5An2VhHKcKevhD0VjJftjH+MD6eR1M9/51F7cGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g9TTYFlyjguoo5HvGrZ2HrvA1K3zPqzG8JvAm1hSKhcyqY0fY49r7gWEInQ9cUU6J
	 ROhuzbHV9cGNK8dG0uBfoRiYwFu552k3/y5Xq8BfPfJpfup05HHadwrWP9FefNMrwn
	 8iPfVieurOJNtSaeCVqz4QpkYbqmYKTmj8YNwvoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	William Breathitt Gray <william.gray@linaro.org>
Subject: [PATCH 6.1 119/131] counter: chrdev: fix getting array extensions
Date: Mon, 16 Oct 2023 10:41:42 +0200
Message-ID: <20231016084003.024645449@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>
References: <20231016084000.050926073@linuxfoundation.org>
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

From: Fabrice Gasnier <fabrice.gasnier@foss.st.com>

commit 3170256d7bc1ef81587caf4b83573eb1f5bb4fb6 upstream.

When trying to watch a component array extension, and the array isn't the
first extended element, it fails as the type comparison is always done on
the 1st element. Fix it by indexing the 'ext' array.

Example on a dummy struct counter_comp:
static struct counter_comp dummy[] = {
	COUNTER_COMP_DIRECTION(..),
	...,
	COUNTER_COMP_ARRAY_CAPTURE(...),
};
static struct counter_count dummy_cnt = {
	...
	.ext = dummy,
	.num_ext = ARRAY_SIZE(dummy),
}

Currently, counter_get_ext() returns -EINVAL when trying to add a watch
event on one of the capture array element in such example.

Fixes: d2011be1e22f ("counter: Introduce the COUNTER_COMP_ARRAY component type")
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Link: https://lore.kernel.org/r/20230829134029.2402868-2-fabrice.gasnier@foss.st.com
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/counter/counter-chrdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/counter/counter-chrdev.c b/drivers/counter/counter-chrdev.c
index 80acdf62794a..afc94d0062b1 100644
--- a/drivers/counter/counter-chrdev.c
+++ b/drivers/counter/counter-chrdev.c
@@ -247,8 +247,8 @@ static int counter_get_ext(const struct counter_comp *const ext,
 		if (*id == component_id)
 			return 0;
 
-		if (ext->type == COUNTER_COMP_ARRAY) {
-			element = ext->priv;
+		if (ext[*ext_idx].type == COUNTER_COMP_ARRAY) {
+			element = ext[*ext_idx].priv;
 
 			if (component_id - *id < element->length)
 				return 0;
-- 
2.42.0



