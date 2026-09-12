Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCD626AC5;
	Sat, 12 Sep 2026 16:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230814; cv=none; b=ELLbxy0r5QCXknFm8+Kw7x9o+MJuIfk8znb5qgXlMH3YBezkkDG7F4Tqq/DeeuaSWPGSn+xRYX+2/n2yTFYuCb/d0e2EgeET3zAWipoVXZp8o2s+l8DQsHWOhAsy+YFWBd3UC4RF47NOwV8QC42mZo+VTZ34oJO6uJxUR2OxI7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230814; c=relaxed/simple;
	bh=63ADUxAERmm9i5ncRkrCkl9MwktcV1kdpX5bbUYe5bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K2FhZlnISpDiXvpnuwfHG1Vm8Ykg0c3t2lZPF8ArkBMxE6JglNYGPFk/8Qm8qaAPzQVaS9/lvt67RZ9Fq/69Wq80jCb/TqCNqR/FTqNxBF878NuYNTTM0Dntoppngl+EXyF2YoGHiH5cbo33SoKQ/08JUCaYhLEQIqYrTEIa22A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V7+THYzc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V7+THYzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352AA1F000FF;
	Sat, 12 Sep 2026 16:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230813;
	bh=d86nO5lfO0x0L+LnpskYOzkfrRMU1hzF4jmGdW687do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V7+THYzcGsBSJuxHvSBv7X+1X6pWuiMXl9bLT01EV+ZZXgnE83/li02pTzJqwnpAV
	 4NZ76I8/SgYExd+cfC+KlghYBY3J1Z0kMZl30OAi+eh7Sbmt9J8D7WIGf2vDCPtstC
	 4LE3HfAu/Cm83GaKbQ+NWf/WNO/ItNiS3ut8ENn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jialu Xu <xujialu@vimux.org>,
	Carlos Llamas <cmllamas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0869/1191] scripts/tags.sh: improve compiled sources generation
Date: Sat, 12 Sep 2026 08:59:57 +0200
Message-ID: <20260912065607.773788847@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f23b9b7ed0159..f6b20f60c914f 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -98,7 +98,7 @@ all_compiled_sources()
 	{
 		echo include/generated/autoconf.h
 		find $ignore -name "*.cmd" -exec \
-			sed -n -E 's/^source_.* (.*)/\1/p; s/^  (\S.*) \\/\1/p' {} \+ |
+			grep -Poh '(?<=^  )\S+|(?<== )\S+[^\\](?=$)' {} \+ |
 		awk '!a[$0]++'
 	} | xargs realpath -esq $([ -z "$KBUILD_ABS_SRCTREE" ] && echo --relative-to=.) |
 	sort -u
-- 
2.53.0



