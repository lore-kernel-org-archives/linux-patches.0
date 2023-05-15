Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9720FBEC
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CCD6C433EF;
	Mon, 15 May 2023 17:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172965;
	bh=sFrfPY7EMkBSX+YimTIkq9AjymcaZRkC1tl3CcGmGv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jCWROsMaHCNIOIqndsOnhdWqG1MCGOKkaEImpUu7tStsmwNGQ4FDdAQp6UHctMfxg
	 l5lew4fP17WUexJqfhy7KkRBE6IkT0i3kxsLPPO3lO82PfY4h83SASIxP7Vi+ilTQg
	 EcbJRnepYeHujGEUBypX5lRgUg3wkG9RD0hoFtto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.10 285/381] dm flakey: fix a crash with invalid table line
Date: Mon, 15 May 2023 18:28:56 +0200
Message-Id: <20230515161749.656204944@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mikulas Patocka <mpatocka@redhat.com>

commit 98dba02d9a93eec11bffbb93c7c51624290702d2 upstream.

This command will crash with NULL pointer dereference:
 dmsetup create flakey --table \
  "0 `blockdev --getsize /dev/ram0` flakey /dev/ram0 0 0 1 2 corrupt_bio_byte 512"

Fix the crash by checking if arg_name is non-NULL before comparing it.

Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-flakey.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -124,9 +124,9 @@ static int parse_features(struct dm_arg_
 			 * Direction r or w?
 			 */
 			arg_name = dm_shift_arg(as);
-			if (!strcasecmp(arg_name, "w"))
+			if (arg_name && !strcasecmp(arg_name, "w"))
 				fc->corrupt_bio_rw = WRITE;
-			else if (!strcasecmp(arg_name, "r"))
+			else if (arg_name && !strcasecmp(arg_name, "r"))
 				fc->corrupt_bio_rw = READ;
 			else {
 				ti->error = "Invalid corrupt bio direction (r or w)";


