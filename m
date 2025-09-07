Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5743F4315A;
	Sun,  7 Sep 2025 20:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277678; cv=none; b=SwzAdLClAW3QFzF7mXxVy37Stzcq6AYTADGZSItBNhfzQypvOSzzK6KKHeb+xa7Imkh34RPsW/VCSiHlcGQSlg7i1V6ajE/5/AwagOvCR5yK11YH48AZPyG7RyKzw3laYYV36HTxOhufgjy4EdhNsc6QKoNLarA70Gmrd0RbVDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277678; c=relaxed/simple;
	bh=W09LrDqSV900QIT6+f5BZo7a7QWl+0U6Aq//i1ds1Ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdVDsevl2EZZ3x2y2sN1y2nKeIkOsA21GnqkGshKNp4CgsIPkGmDpBOHoknc9W6BazyZExwGRp1l677h5++lLF43m4Z7ZpGpkibsKuaxLtKm0l76kFCoUbC69Tvuvh/heBbZAbeA/rWnnpi41i46x4goHo+fD0ZBnAf4mJ0Jcck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yFmhMn0P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yFmhMn0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F5CC4CEF0;
	Sun,  7 Sep 2025 20:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277678;
	bh=W09LrDqSV900QIT6+f5BZo7a7QWl+0U6Aq//i1ds1Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yFmhMn0PmnTboCoQ7o1L7l+IjqCsPStaIcBJQpzYDoTnpBwJ0ZMZSGIAxcC0iAIZF
	 lzzGEMMelinekg628Gm2iqMqQbCvFP9hCs3DiAgWsOPlTyWxZrTZdwONbroFK+gNQR
	 ff0hocz9Q7NXd+aWw80d9g/joSxNOjReEbHyrEFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Chen <yiche@redhat.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 089/183] selftests: netfilter: fix udpclash tool hang
Date: Sun,  7 Sep 2025 21:58:36 +0200
Message-ID: <20250907195617.904585223@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 661a4f307fe0f80c1d544e09476ccba9037e8e65 ]

Yi Chen reports that 'udpclash' loops forever depending on compiler
(and optimization level used); while (x == 1) gets optimized into
for (;;).  Add volatile qualifier to avoid that.

While at it, also run it under timeout(1) and fix the resize script
to not ignore the timeout passed as second parameter to insert_flood.

Reported-by: Yi Chen <yiche@redhat.com>
Suggested-by: Yi Chen <yiche@redhat.com>
Fixes: 78a588363587 ("selftests: netfilter: add conntrack clash resolution test case")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/netfilter/conntrack_clash.sh  | 2 +-
 tools/testing/selftests/net/netfilter/conntrack_resize.sh | 5 +++--
 tools/testing/selftests/net/netfilter/udpclash.c          | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/conntrack_clash.sh b/tools/testing/selftests/net/netfilter/conntrack_clash.sh
index 606a43a60f736..7fc6c5dbd5516 100755
--- a/tools/testing/selftests/net/netfilter/conntrack_clash.sh
+++ b/tools/testing/selftests/net/netfilter/conntrack_clash.sh
@@ -99,7 +99,7 @@ run_one_clash_test()
 	local entries
 	local cre
 
-	if ! ip netns exec "$ns" ./udpclash $daddr $dport;then
+	if ! ip netns exec "$ns" timeout 30 ./udpclash $daddr $dport;then
 		echo "INFO: did not receive expected number of replies for $daddr:$dport"
 		ip netns exec "$ctns" conntrack -S
 		# don't fail: check if clash resolution triggered after all.
diff --git a/tools/testing/selftests/net/netfilter/conntrack_resize.sh b/tools/testing/selftests/net/netfilter/conntrack_resize.sh
index 788cd56ea4a0d..615fe3c6f405d 100755
--- a/tools/testing/selftests/net/netfilter/conntrack_resize.sh
+++ b/tools/testing/selftests/net/netfilter/conntrack_resize.sh
@@ -187,7 +187,7 @@ ct_udpclash()
 	[ -x udpclash ] || return
 
         while [ $now -lt $end ]; do
-		ip netns exec "$ns" ./udpclash 127.0.0.1 $((RANDOM%65536)) > /dev/null 2>&1
+		ip netns exec "$ns" timeout 30 ./udpclash 127.0.0.1 $((RANDOM%65536)) > /dev/null 2>&1
 
 		now=$(date +%s)
 	done
@@ -277,6 +277,7 @@ check_taint()
 insert_flood()
 {
 	local n="$1"
+	local timeout="$2"
 	local r=0
 
 	r=$((RANDOM%$insert_count))
@@ -302,7 +303,7 @@ test_floodresize_all()
 	read tainted_then < /proc/sys/kernel/tainted
 
 	for n in "$nsclient1" "$nsclient2";do
-		insert_flood "$n" &
+		insert_flood "$n" "$timeout" &
 	done
 
 	# resize table constantly while flood/insert/dump/flushs
diff --git a/tools/testing/selftests/net/netfilter/udpclash.c b/tools/testing/selftests/net/netfilter/udpclash.c
index 85c7b906ad08f..79de163d61ab7 100644
--- a/tools/testing/selftests/net/netfilter/udpclash.c
+++ b/tools/testing/selftests/net/netfilter/udpclash.c
@@ -29,7 +29,7 @@ struct thread_args {
 	int sockfd;
 };
 
-static int wait = 1;
+static volatile int wait = 1;
 
 static void *thread_main(void *varg)
 {
-- 
2.50.1



