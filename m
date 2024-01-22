Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DEC01FC4;
	Tue, 23 Jan 2024 01:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972159; cv=none; b=Mwycuhnfbh8PYbvB2YlW6LRVlGAuMyJKjmHZ4pBzk0YdWUXmBmwBoGKP1MsiSMvhzFHIzCE6Rm0Gqy5fAZE4GqbqimOVupJhcvfR5BooFiWVUIkVVvr8VCJfN1dzQShcxrKorsgCFqmb6QBV+Wscwnu3aUN8+YBFShMdqPlSGvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972159; c=relaxed/simple;
	bh=//PaD9DJg5sU4LghpbQ7e4vz3mQ49GnOHLpmUUh1dgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FdJs+o+FLe6tjuPkdwJmsNa4mg/BBdmTU0PZMvaPl+hVu/cGK4XoJwjTny4D2PoXeNVi9jDYdpeBrwH2sJ6ZcphK3aWU7UZ1WcENyHK/Qu4przCCOmcbqnE+fbQ5ZqGZI92lnxGtq3Bw40sMcvevEjhSiC8C/Uxq9Y5Nr5Gp+0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sAFQxNKE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sAFQxNKE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2082C43394;
	Tue, 23 Jan 2024 01:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972159;
	bh=//PaD9DJg5sU4LghpbQ7e4vz3mQ49GnOHLpmUUh1dgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sAFQxNKE8UIs7vYhfSvOb5YdtTNCBhgjV4Z0sIhIQiUPT9obznWvC4GU4z/PKfTz9
	 sXHfjqOl+jpUSAV8AP5D36D1VMTOD2ntnHHwV8OpNUg5qWu3bgIQFdxbL5fDXFH3Fl
	 H7Ju7DH5xfQQHyaj8Lb1frI7343Fztd7zw+sYRFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Maguire <alan.maguire@oracle.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.15 052/374] bpf: Add --skip_encoding_btf_inconsistent_proto, --btf_gen_optimized to pahole flags for v1.25
Date: Mon, 22 Jan 2024 15:55:08 -0800
Message-ID: <20240122235746.410163500@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Maguire <alan.maguire@oracle.com>

commit 7b99f75942da332e3f4f865e55a10fec95a30d4f upstream.

v1.25 of pahole supports filtering out functions with multiple inconsistent
function prototypes or optimized-out parameters from the BTF representation.
These present problems because there is no additional info in BTF saying which
inconsistent prototype matches which function instance to help guide attachment,
and functions with optimized-out parameters can lead to incorrect assumptions
about register contents.

So for now, filter out such functions while adding BTF representations for
functions that have "."-suffixes (foo.isra.0) but not optimized-out parameters.
This patch assumes that below linked changes land in pahole for v1.25.

Issues with pahole filtering being too aggressive in removing functions
appear to be resolved now, but CI and further testing will confirm.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20230510130241.1696561-1-alan.maguire@oracle.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[ small context conflict because of not backported --lang_exclude=rust
option, which is not needed in 5.15 ]
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/pahole-flags.sh |    3 +++
 1 file changed, 3 insertions(+)

--- a/scripts/pahole-flags.sh
+++ b/scripts/pahole-flags.sh
@@ -20,5 +20,8 @@ fi
 if [ "${pahole_ver}" -ge "124" ]; then
 	extra_paholeopt="${extra_paholeopt} --skip_encoding_btf_enum64"
 fi
+if [ "${pahole_ver}" -ge "125" ]; then
+	extra_paholeopt="${extra_paholeopt} --skip_encoding_btf_inconsistent_proto --btf_gen_optimized"
+fi
 
 echo ${extra_paholeopt}


