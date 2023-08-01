Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F931FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50701C433C7;
	Tue,  1 Aug 2023 09:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883057;
	bh=B2mW4Gx0u6r+8zI8UrjHClmYvLOZ1MKRhs4OSPSp+OM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZJ7R48fIIi9oguHA3p2fk37A76mt8BEzwdB05fpJ7vZ31IBEZ+Ox7mnV4Gg8h2Pm3
	 Ou5tgq9+Fpn4SH0dl/gq1s9d0QBX82tb5QcOCf7lXhpSjmyA5XdUP7DLVXD3ACAgon
	 dGpkb8fls+7ntIqhz40yN7qG0NLNFgKJg4VvJKCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Donald Hunter <donald.hunter@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 092/239] tools: ynl-gen: fix enum index in _decode_enum(..)
Date: Tue,  1 Aug 2023 11:19:16 +0200
Message-ID: <20230801091929.060294721@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

[ Upstream commit d7ddf5f4269fcaf19aafe971e635d91897423a3a ]

Remove wrong index adjustment, which is leftover from adding
support for sparse enums.
enum.entries_by_val() function shall not subtract the start-value, as
it is indexed with real enum value.

Fixes: c311aaa74ca1 ("tools: ynl: fix enum-as-flags in the generic CLI")
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
Link: https://lore.kernel.org/r/20230725101642.267248-2-arkadiusz.kubalewski@intel.com
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/ynl/lib/ynl.py | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index 3144f33196be4..35462c7ce48b5 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -405,8 +405,8 @@ class YnlFamily(SpecFamily):
     def _decode_enum(self, rsp, attr_spec):
         raw = rsp[attr_spec['name']]
         enum = self.consts[attr_spec['enum']]
-        i = attr_spec.get('value-start', 0)
         if 'enum-as-flags' in attr_spec and attr_spec['enum-as-flags']:
+            i = 0
             value = set()
             while raw:
                 if raw & 1:
@@ -414,7 +414,7 @@ class YnlFamily(SpecFamily):
                 raw >>= 1
                 i += 1
         else:
-            value = enum.entries_by_val[raw - i].name
+            value = enum.entries_by_val[raw].name
         rsp[attr_spec['name']] = value
 
     def _decode_binary(self, attr, attr_spec):
-- 
2.39.2



