Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90292AD23
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 17:04:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1716CC43470;
	Thu, 27 Oct 2022 17:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666890293;
	bh=et6v1zJ8Tvk9ustQSoPolK6YzHko4XzTLOBxqydmKiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mpKL+jFa0rka/fQ9YzFw2E+DnADcgsNfiKvlfAlLiadlRO/iyd9vAicEVA0tGQhzl
	 Z1pmEeKcp+4C+hF2jHJrdQfVCEYOzpWvt+xZH7oKU4wDcQTcb9fgjyUA8P2lDy9HEm
	 iDsm5M7yAx+4pJxOclpvJDDMj8Pw9jDRNVFKvNkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 5.10 16/79] bpf: Generate BTF_KIND_FLOAT when linking vmlinux
Date: Thu, 27 Oct 2022 18:55:26 +0200
Message-Id: <20221027165054.899070789@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.270676357@linuxfoundation.org>
References: <20221027165054.270676357@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ilya Leoshkevich <iii@linux.ibm.com>

commit db16c1fe92d7ba7d39061faef897842baee2c887  upstream.

[backported for dependency only extra_paholeopt variable setup and
usage, we don't want floats generated in 5.10]

pahole v1.21 supports the --btf_gen_floats flag, which makes it
generate the information about the floating-point types [1].

Adjust link-vmlinux.sh to pass this flag to pahole in case it's
supported, which is determined using a simple version check.

[1] https://lore.kernel.org/dwarves/YHRiXNX1JUF2Az0A@kernel.org/

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210413190043.21918-1-iii@linux.ibm.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/link-vmlinux.sh |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -146,6 +146,7 @@ vmlinux_link()
 gen_btf()
 {
 	local pahole_ver
+	local extra_paholeopt=
 
 	if ! [ -x "$(command -v ${PAHOLE})" ]; then
 		echo >&2 "BTF: ${1}: pahole (${PAHOLE}) is not available"
@@ -161,7 +162,7 @@ gen_btf()
 	vmlinux_link ${1}
 
 	info "BTF" ${2}
-	LLVM_OBJCOPY=${OBJCOPY} ${PAHOLE} -J ${1}
+	LLVM_OBJCOPY=${OBJCOPY} ${PAHOLE} -J ${extra_paholeopt} ${1}
 
 	# Create ${2} which contains just .BTF section but no symbols. Add
 	# SHF_ALLOC because .BTF will be part of the vmlinux image. --strip-all


