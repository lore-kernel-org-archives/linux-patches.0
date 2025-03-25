Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC0825E802;
	Tue, 25 Mar 2025 12:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906428; cv=none; b=MO0r4dgicnvhpvE6JaZIrspFnnAV6Cn3Tf+yNJYNENs8X7qbCNRI15ecUq9+ORWLQ24NvHtEM8/6DyHqWqvf8R2p31DrJ1/Q2oJP9K631RvXia03mEaZRVgtQu6zpZcO0M4iN4fmMWgpKiOqWbeXcv18LdQGPStu6/PJHEp5D/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906428; c=relaxed/simple;
	bh=eXXqMcKadtz2hKc7YZ0hspRu8vba7LqDFJ8shqIqiBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HjSnKILsXCCVvWjtBpY6b75fLiAo1EVxlKU2iQpDOA/x3oac0dMO0YS6SQvKVBFYc66gD0/6K88qai6RDPYyF+gP+wmeG5+PY6VwjLwQyCHDd+HDGqOhjqsqtOPBgAiJqo52hkWpxvqoehSWdf8sLRq6zt3DVzUMJrh06/EAX6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DSlLDKNc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DSlLDKNc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4430C4CEE4;
	Tue, 25 Mar 2025 12:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906428;
	bh=eXXqMcKadtz2hKc7YZ0hspRu8vba7LqDFJ8shqIqiBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DSlLDKNcruxJw1BwB71V8KPTOnoy6H3l60D2JaTBZvuWkqchIZ4lT6ebI9fI+JSPS
	 3bZ0rExGvfiV2/pkwpEo/S89pn5fQKHh6O4jQv3+57faBVmcGook49Pt8T+7A7c9GA
	 wxx0d5yDkignRb6s/06IveKOeWDqW7k4F+fBLPCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eder Zulian <ezulian@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Bin Lan <bin.lan.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.12 113/116] libsubcmd: Silence compiler warning
Date: Tue, 25 Mar 2025 08:23:20 -0400
Message-ID: <20250325122152.095888538@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eder Zulian <ezulian@redhat.com>

commit 7a4ffec9fd54ea27395e24dff726dbf58e2fe06b upstream.

Initialize the pointer 'o' in options__order to NULL to prevent a
compiler warning/error which is observed when compiling with the '-Og'
option, but is not emitted by the compiler with the current default
compilation options.

For example, when compiling libsubcmd with

 $ make "EXTRA_CFLAGS=-Og" -C tools/lib/subcmd/ clean all

Clang version 17.0.6 and GCC 13.3.1 fail to compile parse-options.c due
to following error:

  parse-options.c: In function ‘options__order’:
  parse-options.c:832:9: error: ‘o’ may be used uninitialized [-Werror=maybe-uninitialized]
    832 |         memcpy(&ordered[nr_opts], o, sizeof(*o));
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parse-options.c:810:30: note: ‘o’ was declared here
    810 |         const struct option *o, *p = opts;
        |                              ^
  cc1: all warnings being treated as errors

Signed-off-by: Eder Zulian <ezulian@redhat.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/bpf/20241022172329.3871958-4-ezulian@redhat.com
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/lib/subcmd/parse-options.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/lib/subcmd/parse-options.c
+++ b/tools/lib/subcmd/parse-options.c
@@ -807,7 +807,7 @@ static int option__cmp(const void *va, c
 static struct option *options__order(const struct option *opts)
 {
 	int nr_opts = 0, nr_group = 0, nr_parent = 0, len;
-	const struct option *o, *p = opts;
+	const struct option *o = NULL, *p = opts;
 	struct option *opt, *ordered = NULL, *group;
 
 	/* flatten the options that have parents */


