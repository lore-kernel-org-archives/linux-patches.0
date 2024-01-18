Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A601D22F16;
	Thu, 18 Jan 2024 11:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575735; cv=none; b=EUfSSn+D+5lF4ih7Vajglg4qgpNfTqreP2WBbzXBAyYJkF7ifvIO2XejAAd/5iqy+xdd7+Ahp5p3B2aXmg1bcDrUVCpGojVA/6COceQL6OREozHjPwkwoVm9MVooLc0hhUu/jXZUY1XLqibwB8MtsEbe3YvM0V1Bb9I3RiJApX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575735; c=relaxed/simple;
	bh=ibtoKBimtJxzBubcFTT01bnNHwPILlxsoUeH+yu6nMk=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=stw7+Au0WGs6lhlm3CxIBtUKqo3QpmCLE/2cHkDjPvxWgdOw2XMav2FyBJBQz0/h9vPiSzV3OI04L4sjG7fzi2M1VZbqpmwkPyKFd3D4IaoNIRLgbkoqy6+jrkbiREE1NbJa/7F6B84GY/ci7hWGdfGT/UHkhljnWzuHvZpRVzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=06DU6VXi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="06DU6VXi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24555C433F1;
	Thu, 18 Jan 2024 11:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575735;
	bh=ibtoKBimtJxzBubcFTT01bnNHwPILlxsoUeH+yu6nMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=06DU6VXiAauVh/fq0DqfeGgnZHqIhD5LKTLUFq2y9OzTVJeYr+TvCTuPJ1qJr9Y64
	 2fbXE8dA3Ez+dC6eNPAD5w63xe6651nfpSSWqigGRbhRZhgGv7HX7PnPELm1FvIshl
	 HQNUUYfTCd02Vn1t0YEzJ4IVQbNAXhC1AI0cbx+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Maguire <alan.maguire@oracle.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.1 086/100] bpf: Add --skip_encoding_btf_inconsistent_proto, --btf_gen_optimized to pahole flags for v1.25
Date: Thu, 18 Jan 2024 11:49:34 +0100
Message-ID: <20240118104314.641439633@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/pahole-flags.sh |    3 +++
 1 file changed, 3 insertions(+)

--- a/scripts/pahole-flags.sh
+++ b/scripts/pahole-flags.sh
@@ -23,5 +23,8 @@ if [ "${pahole_ver}" -ge "124" ]; then
 	# see PAHOLE_HAS_LANG_EXCLUDE
 	extra_paholeopt="${extra_paholeopt} --lang_exclude=rust"
 fi
+if [ "${pahole_ver}" -ge "125" ]; then
+	extra_paholeopt="${extra_paholeopt} --skip_encoding_btf_inconsistent_proto --btf_gen_optimized"
+fi
 
 echo ${extra_paholeopt}


