Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4B41AAE2C;
	Mon, 14 Oct 2024 14:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916040; cv=none; b=j9kuH/Vl1V/7MH79y72k7d9l0VjVo1IIS0CJkOxmMRvRY6jFz5GTAdFpryK8sWbmKeFlYIE4CgPuNsIA2E6dnYKUBnx+2xkiyyj5ukPXXIU65ojVqk6pdtqPVHQplMg5pVRdt8EGM058dgWgBhRGHsE7yzCH3gY0uSIl0/LroNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916040; c=relaxed/simple;
	bh=r/lRvqlt2AyvGtj3JyDAw54m4bfKhXaGPLin8nOo1eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RmWb2PkJzcqP1gcxvOreXE+xuH5WzP8GBI6LZ+EC0rsImjvfMV0NHviQjMjzlKJkpSp3wEjbaV78bTeXivP3uJGpx4tIe+IqSZzff6M5e+TIm0OtOwlfsXifmH1V1qCqNVexEGZpx5a9DI9s8liKqucYnuzNP6Hzo0xFPC1N9mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4US+2Y9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4US+2Y9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A252CC4CEC3;
	Mon, 14 Oct 2024 14:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916040;
	bh=r/lRvqlt2AyvGtj3JyDAw54m4bfKhXaGPLin8nOo1eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W4US+2Y9THVLPlJ4iurzOsfgtbxu/9unDW9p3BBivrGjQ5PmfAXhtTXYCAZ7UKd+G
	 cYrRh+wS1QQ4qvqrFkaNbQiDBVs/xcIL6i0bUUd3B4CRA8Gzg97AMAQrRnW8X1M+Kw
	 mA42qQwaZEaJiBWXS9Eq/GlWaRtM3sDgWOePHEdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ken Raeburn <raeburn@redhat.com>,
	Matthew Sakai <msakai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 069/214] dm vdo: dont refer to dedupe_context after releasing it
Date: Mon, 14 Oct 2024 16:18:52 +0200
Message-ID: <20241014141047.683380021@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ken Raeburn <raeburn@redhat.com>

[ Upstream commit 0808ebf2f80b962e75741a41ced372a7116f1e26 ]

Clear the dedupe_context pointer in a data_vio whenever ownership of
the context is lost, so that vdo can't examine it accidentally.

Signed-off-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-vdo/dedupe.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index 39ac68614419f..80628ae93fbac 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -729,6 +729,7 @@ static void process_update_result(struct data_vio *agent)
 	    !change_context_state(context, DEDUPE_CONTEXT_COMPLETE, DEDUPE_CONTEXT_IDLE))
 		return;
 
+	agent->dedupe_context = NULL;
 	release_context(context);
 }
 
@@ -1648,6 +1649,7 @@ static void process_query_result(struct data_vio *agent)
 
 	if (change_context_state(context, DEDUPE_CONTEXT_COMPLETE, DEDUPE_CONTEXT_IDLE)) {
 		agent->is_duplicate = decode_uds_advice(context);
+		agent->dedupe_context = NULL;
 		release_context(context);
 	}
 }
@@ -2321,6 +2323,7 @@ static void timeout_index_operations_callback(struct vdo_completion *completion)
 		 * send its requestor on its way.
 		 */
 		list_del_init(&context->list_entry);
+		context->requestor->dedupe_context = NULL;
 		continue_data_vio(context->requestor);
 		timed_out++;
 	}
-- 
2.43.0



