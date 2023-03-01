Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4506A847A
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:10:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE616C433D2;
	Wed,  1 Mar 2023 18:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677694251;
	bh=sL9E7aXqzAJeeCcVzyUJVpyYHQXqHP5+00clrvbzG9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0P5Wu4RBr0GVlvA5MYb/+89Gl1dMNjIcA0crE6wjG80XC+QDPv1I/1/j5pc6Du9D5
	 DrmpXcuAqSghzvel/8VGQUgELjj593RxKSN8D2FWyasyw/Ly3/b1ac2JOnkYhWBH83
	 PCXaK1EEoDaMKgwXjbxnH4VVqgDAE8Wkl58V7pPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 5.15 17/22] scripts/tags.sh: Invoke realpath via xargs
Date: Wed,  1 Mar 2023 19:08:50 +0100
Message-Id: <20230301180653.342663439@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180652.658125575@linuxfoundation.org>
References: <20230301180652.658125575@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

commit 7394d2ebb651a9f62e08c6ab864aac015d27c64d upstream.

When COMPILED_SOURCE is set, running

  make ARCH=x86_64 COMPILED_SOURCE=1 cscope tags

could throw the following errors:

scripts/tags.sh: line 98: /usr/bin/realpath: Argument list too long
cscope: no source files found
scripts/tags.sh: line 98: /usr/bin/realpath: Argument list too long
ctags: No files specified. Try "ctags --help".

This is most likely to happen when the kernel is configured to build a
large number of modules, which has the consequence of passing too many
arguments when calling 'realpath' in 'all_compiled_sources()'.

Let's improve this by invoking 'realpath' through 'xargs', which takes
care of properly limiting the argument list.

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://lore.kernel.org/r/20220516234646.531208-1-cristian.ciocaltea@collabora.com
Cc: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/tags.sh |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -95,10 +95,13 @@ all_sources()
 
 all_compiled_sources()
 {
-	realpath -es $([ -z "$KBUILD_ABS_SRCTREE" ] && echo --relative-to=.) \
-		include/generated/autoconf.h $(find $ignore -name "*.cmd" -exec \
-		grep -Poh '(?(?=^source_.* \K).*|(?=^  \K\S).*(?= \\))' {} \+ |
-		awk '!a[$0]++') | sort -u
+	{
+		echo include/generated/autoconf.h
+		find $ignore -name "*.cmd" -exec \
+			grep -Poh '(?(?=^source_.* \K).*|(?=^  \K\S).*(?= \\))' {} \+ |
+		awk '!a[$0]++'
+	} | xargs realpath -es $([ -z "$KBUILD_ABS_SRCTREE" ] && echo --relative-to=.) |
+	sort -u
 }
 
 all_target_sources()


