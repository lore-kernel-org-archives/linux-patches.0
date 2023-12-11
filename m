Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C505102A;
	Mon, 11 Dec 2023 18:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YCVGSk8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F57C433C7;
	Mon, 11 Dec 2023 18:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320612;
	bh=/n2cot85qd07o5WP8O1H2rTucFw2h1KknEF34yk6jOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YCVGSk8F4IsnOUVte+u/Ya+PW8LCEauZih4sRBHHxFZ59t69d7afUaGjpoWhUuX+/
	 rR/NFKYjXqfwuyvzwbmPF0xCPblO0DYctJ1hSrbqvGTDaNss7UIAxZN1hp2WCtRrFm
	 MsBXuQgdXHJYTAy38eeOoeIUUy1O0CExC6kCrEQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jeffery <djeffery@redhat.com>,
	Laurence Oberman <loberman@redhat.com>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.1 126/194] md/raid6: use valid sector values to determine if an I/O should wait on the reshape
Date: Mon, 11 Dec 2023 19:21:56 +0100
Message-ID: <20231211182042.157472190@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

From: David Jeffery <djeffery@redhat.com>

commit c467e97f079f0019870c314996fae952cc768e82 upstream.

During a reshape or a RAID6 array such as expanding by adding an additional
disk, I/Os to the region of the array which have not yet been reshaped can
stall indefinitely. This is from errors in the stripe_ahead_of_reshape
function causing md to think the I/O is to a region in the actively
undergoing the reshape.

stripe_ahead_of_reshape fails to account for the q disk having a sector
value of 0. By not excluding the q disk from the for loop, raid6 will always
generate a min_sector value of 0, causing a return value which stalls.

The function's max_sector calculation also uses min() when it should use
max(), causing the max_sector value to always be 0. During a backwards
rebuild this can cause the opposite problem where it allows I/O to advance
when it should wait.

Fixing these errors will allow safe I/O to advance in a timely manner and
delay only I/O which is unsafe due to stripes in the middle of undergoing
the reshape.

Fixes: 486f60558607 ("md/raid5: Check all disks in a stripe_head for reshape progress")
Cc: stable@vger.kernel.org # v6.0+
Signed-off-by: David Jeffery <djeffery@redhat.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20231128181233.6187-1-djeffery@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid5.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5905,11 +5905,11 @@ static bool stripe_ahead_of_reshape(stru
 	int dd_idx;
 
 	for (dd_idx = 0; dd_idx < sh->disks; dd_idx++) {
-		if (dd_idx == sh->pd_idx)
+		if (dd_idx == sh->pd_idx || dd_idx == sh->qd_idx)
 			continue;
 
 		min_sector = min(min_sector, sh->dev[dd_idx].sector);
-		max_sector = min(max_sector, sh->dev[dd_idx].sector);
+		max_sector = max(max_sector, sh->dev[dd_idx].sector);
 	}
 
 	spin_lock_irq(&conf->device_lock);


