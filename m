Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20FA89443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4F9C433C8;
	Sun, 13 Aug 2023 21:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962039;
	bh=sThYTK08FrQ5nNxppzIP45CgutzvRpbj55Ox3mvGBHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bo2YpjuPWxosk5y7S4URrf97wHHKgPFZ0BYZW7GbGnBzOgae54A5mZhduvBKzVbUH
	 mBg0xqYZC2p+ZsoH0iUS7//pW7rv1CQFSdUnQTLXiSsy8SiMsibMsSes2TH4rrbDne
	 sNUbFN6z5/5lgEPnCgd/HaUMQmTvLTDc6aFRna4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ayush Jain <ayush.jain3@amd.com>,
	David Hildenbrand <david@redhat.com>,
	Stefan Roesch <shr@devkernel.io>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.4 061/206] selftests: mm: ksm: fix incorrect evaluation of parameter
Date: Sun, 13 Aug 2023 23:17:11 +0200
Message-ID: <20230813211726.816613756@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ayush Jain <ayush.jain3@amd.com>

commit 65294de30cb8bc7659e445f7be2846af9ed35499 upstream.

A missing break in kms_tests leads to kselftest hang when the parameter -s
is used.

In current code flow because of missing break in -s, -t parses args
spilled from -s and as -t accepts only valid values as 0,1 so any arg in
-s >1 or <0, gets in ksm_test failure

This went undetected since, before the addition of option -t, the next
case -M would immediately break out of the switch statement but that is no
longer the case

Add the missing break statement.

----Before----
./ksm_tests -H -s 100
Invalid merge type

----After----
./ksm_tests -H -s 100
Number of normal pages:    0
Number of huge pages:    50
Total size:    100 MiB
Total time:    0.401732682 s
Average speed:  248.922 MiB/s

Link: https://lkml.kernel.org/r/20230728163952.4634-1-ayush.jain3@amd.com
Fixes: 07115fcc15b4 ("selftests/mm: add new selftests for KSM")
Signed-off-by: Ayush Jain <ayush.jain3@amd.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Stefan Roesch <shr@devkernel.io>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/ksm_tests.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/mm/ksm_tests.c b/tools/testing/selftests/mm/ksm_tests.c
index 435acebdc325..380b691d3eb9 100644
--- a/tools/testing/selftests/mm/ksm_tests.c
+++ b/tools/testing/selftests/mm/ksm_tests.c
@@ -831,6 +831,7 @@ int main(int argc, char *argv[])
 				printf("Size must be greater than 0\n");
 				return KSFT_FAIL;
 			}
+			break;
 		case 't':
 			{
 				int tmp = atoi(optarg);
-- 
2.41.0



