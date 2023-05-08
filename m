Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D09168D1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0B4C433D2;
	Mon,  8 May 2023 11:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545289;
	bh=CPqYJM3/bse83eMz/FeEinnYs3/0/El4TpEx5F3NN0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n8IsqJIFKbJhTqf4w15BQV+M7fVoHQiNgorc5g4vS5dvwnE9DdjSbM0ELTNAvydw9
	 O7ndyAIMw3jrZ1XYKXWLvsg8zalHweN85kcgxXV9dXkfE4pW4hC0dEs9nlsaUVpfXa
	 OgQp81aJixYLagXFPYiMfyAmTXVfe/kWGZiLbdC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Holl <tobias@tholl.xyz>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.3 687/694] io_uring/rsrc: check for nonconsecutive pages
Date: Mon,  8 May 2023 11:48:42 +0200
Message-Id: <20230508094458.678191803@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tobias Holl <tobias@tholl.xyz>

commit 776617db78c6d208780e7c69d4d68d1fa82913de upstream.

Pages that are from the same folio do not necessarily need to be
consecutive. In that case, we cannot consolidate them into a single bvec
entry. Before applying the huge page optimization from commit 57bebf807e2a
("io_uring/rsrc: optimise registered huge pages"), check that the memory
is actually consecutive.

Cc: stable@vger.kernel.org
Fixes: 57bebf807e2a ("io_uring/rsrc: optimise registered huge pages")
Signed-off-by: Tobias Holl <tobias@tholl.xyz>
[axboe: formatting]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rsrc.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1230,7 +1230,12 @@ static int io_sqe_buffer_register(struct
 	if (nr_pages > 1) {
 		folio = page_folio(pages[0]);
 		for (i = 1; i < nr_pages; i++) {
-			if (page_folio(pages[i]) != folio) {
+			/*
+			 * Pages must be consecutive and on the same folio for
+			 * this to work
+			 */
+			if (page_folio(pages[i]) != folio ||
+			    pages[i] != pages[i - 1] + 1) {
 				folio = NULL;
 				break;
 			}


