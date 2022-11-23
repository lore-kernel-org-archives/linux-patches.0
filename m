Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B0F1C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2142C433C1;
	Wed, 23 Nov 2022 09:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197482;
	bh=8c+6djlqgElR9yErWZlCKtrSSvUjTzJ5YFeukv8w3Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NrTnJL6NIbz6x5FsmcHjhNmBPMWT7dHML6hlqQTI5CmHcyV8+9yfYFPonMiutzD2a
	 o8F5dhPTSZuFAI0efxM0op9kDtxCUqTR8SDL+YVVIKky4Sq2H0RnkGvtsXPFhqbDof
	 Dm9gu6Cu26fehMs+7/RlVNxYVp/jz2rWGjRysH1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@fb.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jens Axboe <axboe@kernel.dk>,
	Rik van Riel <riel@surriel.com>
Subject: [PATCH 6.0 276/314] blk-cgroup: properly pin the parent in blkcg_css_online
Date: Wed, 23 Nov 2022 09:52:01 +0100
Message-Id: <20221123084638.040660384@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chris Mason <clm@fb.com>

commit d7dbd43f4a828fa1d9a8614d5b0ac40aee6375fe upstream.

blkcg_css_online is supposed to pin the blkcg of the parent, but
397c9f46ee4d refactored things and along the way, changed it to pin the
css instead.  This results in extra pins, and we end up leaking blkcgs
and cgroups.

Fixes: 397c9f46ee4d ("blk-cgroup: move blkcg_{pin,unpin}_online out of line")
Signed-off-by: Chris Mason <clm@fb.com>
Spotted-by: Rik van Riel <riel@surriel.com>
Cc: <stable@vger.kernel.org> # v5.19+
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Link: https://lore.kernel.org/r/20221114181930.2093706-1-clm@fb.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1251,7 +1251,7 @@ static int blkcg_css_online(struct cgrou
 	 * parent so that offline always happens towards the root.
 	 */
 	if (parent)
-		blkcg_pin_online(css);
+		blkcg_pin_online(&parent->css);
 	return 0;
 }
 


