Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861AABA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:15:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8485C433EF;
	Tue,  7 Mar 2023 17:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209340;
	bh=bWNO8Q7CGYhzmhgMuMZjNfhlYK7+h9yjxc4PQ6Sm+ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TOceiPZZ74edDYrMALifu5ekC3mQIalREqau/rAcMa+0D6vN6UXE8T8pEa+FtHMmF
	 +bPU2QfOKa8qF36dRG7a+h8KzdeLprTocKE0gfPpQu28g+c9wZ+6vFmKrHHo27CqBH
	 9TXRXxkZ7F8mdfhP08R7xHRegwPLFihoHoUVhVLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Suchanek <msuchanek@suse.de>,
	Andrii Nakryiko <andrii@kernel.org>,
	Quentin Monnet <quentin@isovalent.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0186/1001] bpf_doc: Fix build error with older python versions
Date: Tue,  7 Mar 2023 17:49:18 +0100
Message-Id: <20230307170029.965599721@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michal Suchanek <msuchanek@suse.de>

[ Upstream commit 5fbea42387eba1c7517fcad79099df706def7054 ]

The ability to subscript match result as an array is only available
since python 3.6. Existing code in bpf_doc uses the older group()
interface but commit 8a76145a2ec2 adds code using the new interface.

Use the old interface consistently to avoid build error on older
distributions like the below:

+ make -j48 -s -C /dev/shm/kbuild/linux.33946/current ARCH=powerpc HOSTCC=gcc CROSS_COMPILE=powerpc64-suse-linux- clean
TypeError: '_sre.SRE_Match' object is not subscriptable

Fixes: 8a76145a2ec2 ("bpf: explicitly define BPF_FUNC_xxx integer values")
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Quentin Monnet <quentin@isovalent.com>
Link: https://lore.kernel.org/bpf/20230109113442.20946-1-msuchanek@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/bpf_doc.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/bpf_doc.py b/scripts/bpf_doc.py
index e8d90829f23ed..38d51e05c7a2b 100755
--- a/scripts/bpf_doc.py
+++ b/scripts/bpf_doc.py
@@ -271,7 +271,7 @@ class HeaderParser(object):
             if capture:
                 fn_defines_str += self.line
                 helper_name = capture.expand(r'bpf_\1')
-                self.helper_enum_vals[helper_name] = int(capture[2])
+                self.helper_enum_vals[helper_name] = int(capture.group(2))
                 self.helper_enum_pos[helper_name] = i
                 i += 1
             else:
-- 
2.39.2



