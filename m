Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D0A39150B;
	Sat, 12 Sep 2026 19:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243148; cv=none; b=uzoG2iy2Lnl59MotgluuirlLF5X/nKArXPeGkVwvnF+g5pAPge3UXSXB6z+8Q8CL8hChv4uDUoZ2wjiJ/L596Whow06vNgu7xIfzkcQJeDzVs1IVcyweGck0ebkQme5JIhRgKu6wKyZjDaM3rkp0RAhI+YEiMhN2AZWY8vxefqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243148; c=relaxed/simple;
	bh=RmKYZwM/8hpZ5fqw28lzlZdA+T1n8YxCWJe/MiExerU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iod4G7kXH5993b53jdSXcafhwG2d2kVvl8nnJcs1tqBhY4452j38zKgHxXT3MVf4Tl+4mk2+e8ygUhWVBkfq03zhmx4lwFpPjAL36lA60D1D1b1lMeSHs8AHSdL5hZgXMzU9OBAEZE+8mQIYmWMZcn9zj0eV3q2tTUZFcduzf7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u7Xc2JYh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u7Xc2JYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817F41F000FF;
	Sat, 12 Sep 2026 19:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243146;
	bh=0AQ/6OkC/74eLDtpPkuRFC17CqDmVBHZDNyVfQagGUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u7Xc2JYhkmBnNV44wDOt8loUK8YA6IpH/vBkJTswSj1flRTl5VimYWaAH8zFM7PNj
	 MUlVtCgtS2Zk2ktt10htMoJpxbBnCRsvGdrQRaErBpUyUP6AsMGiOdW0t2F8JAXX8B
	 66IwHFLyypiqjqxdDwwIpoEo/3QQ1aQi9KHu7Tak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jialu Xu <xujialu@vimux.org>,
	Carlos Llamas <cmllamas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 610/798] scripts/tags.sh: improve compiled sources generation
Date: Sat, 12 Sep 2026 09:03:58 +0200
Message-ID: <20260912065531.104425078@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jialu Xu <xujialu@vimux.org>

[ Upstream commit 82089b00ae026f638277c51bf3f36c68ed4021c7 ]

Use grep instead of sed for all compiled sources generation, it is three
times more efficient.

Signed-off-by: Jialu Xu <xujialu@vimux.org>
Tested-by: Carlos Llamas <cmllamas@google.com>
Link: https://lore.kernel.org/r/20230601010402.71040-1-xujialu@vimux.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: a9b93c34625a ("scripts/tags.sh: Prevent binary files appearing in cscope.files")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/tags.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index d17801c9d85a0..5dd016e48e1ac 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -105,7 +105,7 @@ all_compiled_sources()
 	{
 		echo include/generated/autoconf.h
 		find $ignore -name "*.cmd" -exec \
-			sed -n -E 's/^source_.* (.*)/\1/p; s/^  (\S.*) \\/\1/p' {} \+ |
+			grep -Poh '(?<=^  )\S+|(?<== )\S+[^\\](?=$)' {} \+ |
 		awk '!a[$0]++'
 	} | xargs realpath -es $([ -z "$KBUILD_ABS_SRCTREE" ] && echo --relative-to=.) |
 	sort -u
-- 
2.53.0



