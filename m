Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3629728E02
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p0NOvO6n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C73C433C9;
	Mon, 16 Oct 2023 14:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697468153;
	bh=3mJ1rWpURbr2POamyVFCy4nVWL3KtQ8SC0VTgyzedNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p0NOvO6n/tkPpKdPujv7H+lNha94G9I1WML0hjt6mYb5XhQMv5T7W6OL3Qqa2PJVe
	 yaitQvLTdoXouRFhXzAPOEgLU3W7ZHIP7EeWOiFIfoemGbxBe+tdKXMfRBr9DqXAy/
	 +X2pJ9+VQp6odLnNOhLgFRJf+4YkreHS2epmHzP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	William Breathitt Gray <william.gray@linaro.org>
Subject: [PATCH 6.5 168/191] counter: chrdev: fix getting array extensions
Date: Mon, 16 Oct 2023 10:42:33 +0200
Message-ID: <20231016084019.297882649@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/counter/counter-chrdev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/counter/counter-chrdev.c
+++ b/drivers/counter/counter-chrdev.c
@@ -247,8 +247,8 @@ static int counter_get_ext(const struct
 		if (*id == component_id)
 			return 0;
 
-		if (ext->type == COUNTER_COMP_ARRAY) {
-			element = ext->priv;
+		if (ext[*ext_idx].type == COUNTER_COMP_ARRAY) {
+			element = ext[*ext_idx].priv;
 
 			if (component_id - *id < element->length)
 				return 0;


